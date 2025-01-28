//
//  TileGridView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/27/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TileGridView: View {
    let db = Firestore.firestore()
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    @Binding var selectedCategory: String
    @Binding var selectedBrand: String
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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredData()) { product in
                    TileView(product: product)
                        .frame(height: 200)
                        .onTapGesture {
                            if let email = userAuth.email {
                                Task {
                                    await toggleLike(product: product, email: email)
                                }
                                
                            } else {
                                errorMessage = "not logged in"
                            }
                        }
                        .onLongPressGesture {
                            if let email = userAuth.email {
                                Task {
                                    await toggleDislike(product: product, email: email)
                                }
                                
                            } else {
                                errorMessage = "not logged in"
                            }
                        }
                        .overlay(
                            likedProducts.contains(product) ?
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .padding(8)
                            : nil,
                            alignment: .topLeading
                            
                        )
                        .overlay(
                            dislikedProducts.contains(product) ?
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .padding(8)
                            : nil,
                            alignment: .topTrailing
                        )
                }
            }
            .padding()
        }
        Text("Liked Products:")
        .font(.headline)
        .padding(.top)

        ScrollView(.horizontal) {
            HStack {
                ForEach(likedProducts, id: \.id) { product in
                    Text(product.brand) // Replace with product's name or identifier
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
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
                            amount: data["amount"] as? String ?? "Other"
                        )
                    }
        } catch {
          print("Error getting documents: \(error)")
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
/*
 #Preview {
 TileGridView()
 }
 */
