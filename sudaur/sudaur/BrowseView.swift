//
//  BrowseView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BrowseView: View {
    let db = Firestore.firestore()
    @State private var tileMode = "grid"
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    @State private var selectedCategory = "All"
    @State private var selectedBrand = "All"
    let categories = ["All", "Apparel", "Nutrition", "Recovery", "Other"]
    
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var errorMessage = ""
    @State private var allProducts: [Product] = []
    @State private var likedProducts: [Product] = []
    @State private var dislikedProducts: [Product] = []
    @State private var documentData: [String: Any]? = nil
    @State private var userLikedProducts: [String] = []
    @State private var userDislikedProducts: [String] = []
    
    var brands: [String] {
            let allBrands = allProducts.map { $0.brand }
            let uniqueBrands = Set(allBrands)
            return ["All"] + uniqueBrands.sorted()
    }
    var body: some View {
        Text("Browse!")
        Text(errorMessage)
        HStack {
            Spacer()
            if tileMode == "grid" {
                Button(action: {
                    tileMode = "swipe"
                }) {
                    Image(systemName: "square.on.square")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white.opacity(1))
                        .clipShape(Circle())
                        .padding(8)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 2)
                        )
                }
            } else {
                Button(action: {
                    tileMode = "grid"
                }) {
                    Image(systemName: "square.grid.3x3.square")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white.opacity(1))
                        .clipShape(Circle())
                        .padding(8)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 2)
                        )
                        
                        
                }
            }
            Spacer()
            Picker("Filter", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .border(Color.black)
            Spacer()
            Picker("Filter", selection: $selectedBrand) {
                ForEach(brands, id: \.self) { brand in Text(brand).tag(brand)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .border(Color.black)
            Spacer()
        }
        if tileMode == "grid" {
            TileGridView(selectedCategory: $selectedCategory, selectedBrand: $selectedBrand)
        } else {
            TileStackView(selectedCategory: $selectedCategory, selectedBrand: $selectedBrand)
        }
        
        Spacer()
        .task {
            do {
                await fetchTileData() // Load products first
                if let email = userAuth.email {
                    await fetchUserData(email: email) // Fetch user-specific data
                } else {
                    errorMessage = "Not logged in"
                }
            } catch {
                errorMessage = "Failed to load data: \(error.localizedDescription)"
            }
        }
    }
    func filteredData() -> [Product] {
        if selectedCategory == "All" && selectedBrand == "All" {
            return allProducts
        } else if selectedCategory == "All" {
            return allProducts.filter {
                $0.brand as String == selectedBrand
            }
        } else if selectedBrand == "All" {
            return allProducts.filter {
                $0.category as String == selectedCategory
            }
        } else {
            return allProducts.filter { $0.category as String == selectedCategory && $0.brand as String == selectedBrand}
        }
    }
    func fetchTileData() async {
        do {
          let querySnapshot = try await db.collection("products").getDocuments()
            allProducts = querySnapshot.documents.map { document in
                        let data = document.data()
                        return Product(
                            id: document.documentID,
                            brand: data["brand"] as? String ?? "Unknown",
                            product: data["product"] as? String ?? "N/A",
                            category: data["category"] as? String ?? "Other",
                            amount: data["amount"] as? String ?? "Other",
                            description: data["description"] as? String ?? "Other"
                        )
                    }
        } catch {
          print("Error getting documents: \(error)")
        }
    }
    func toggleLike(product: Product, email: String) async {
        if let index = likedProducts.firstIndex(of: product) {
                // If the product is already liked, remove it
                likedProducts.remove(at: index)
                if let idIndex = userLikedProducts.firstIndex(of: product.id) {
                    userLikedProducts.remove(at: idIndex)
                }
            } else {
                // Add the product to liked products
                likedProducts.append(product)
                userLikedProducts.append(product.id)
            }
        let updatedData: [String: Any] = ["likedProducts": userLikedProducts]
        do {
            try await db.collection("users").document(email).setData(updatedData, merge: true)
            print("Liked products updated successfully!")
        } catch {
            print("Error updating liked products: \(error.localizedDescription)")
        }

    }
    func toggleDislike(product: Product, email: String) async {
        if let index = dislikedProducts.firstIndex(of: product) {
                // If the product is already disliked, remove it
                dislikedProducts.remove(at: index)
                if let idIndex = userDislikedProducts.firstIndex(of: product.id) {
                    userDislikedProducts.remove(at: idIndex)
                }
            } else {
                // Add the product to liked products
                dislikedProducts.append(product)
                userDislikedProducts.append(product.id)
            }
        let updatedData: [String: Any] = ["dislikedProducts": userDislikedProducts]
        do {
            try await db.collection("users").document(email).setData(updatedData, merge: true)
            print("Disliked products updated successfully!")
        } catch {
            print("Error updating liked products: \(error.localizedDescription)")
        }

    }
    func fetchUserData(email: String) async {
            let docRef = db.collection("users").document(email)
            do {
                let document = try await docRef.getDocument()
                if document.exists {
                    documentData = document.data()
                    // Initialize local fields with fetched data
                    
                    userLikedProducts = documentData?["likedProducts"] as? [String] ?? []
                    likedProducts = userLikedProducts.compactMap { id in allProducts.first(where: { $0.id == id
                    })
                                }
                    userDislikedProducts = documentData?["dislikedProducts"] as? [String] ?? []
                    dislikedProducts = userDislikedProducts.compactMap { id in allProducts.first(where: { $0.id == id
                    })
                                }
                } else {
                    errorMessage = "Document does not exist"
                }
            } catch {
                errorMessage = error.localizedDescription
            }
    }
}

struct Product: Identifiable, Equatable {
    var id: String // Document ID from Firestore
    var brand: String
    var product: String
    var category: String
    var amount: String
    var description: String
}

#Preview {
    BrowseView()
        .environmentObject(UserAuthentication())
}
