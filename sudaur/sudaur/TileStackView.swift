//
//  TileStackView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/20/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TileStackView: View {
    let db = Firestore.firestore()
    
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var likedProducts: [Product] = []
    @State private var dislikedProducts: [Product] = []
    @State private var allProducts: [Product] = []
    @State private var errorMessage = ""
    @State private var userLikedProducts: [String] = []
    @State private var userDislikedProducts: [String] = []
    @State private var documentData: [String: Any]? = nil
    @Binding var selectedCategory: String
    @Binding var selectedBrand: String
    let categories = ["All", "Apparel", "Nutrition", "Recovery", "Other"]
    var brands: [String] {
            let allBrands = allProducts.map { $0.brand }
            let uniqueBrands = Set(allBrands)
            return ["All"] + uniqueBrands.sorted()
    }
    var body: some View {
        let unprocessedProducts = filteredData().filter { product in
            !likedProducts.contains(where: { $0.id == product.id }) &&
            !dislikedProducts.contains(where: { $0.id == product.id })
        }
        Text("Swipe!")
        .font(.headline)
        ZStack {
            ForEach(unprocessedProducts, id: \.id) { product in
                if let index = unprocessedProducts.firstIndex(where: { $0.id == product.id }) {
                    SwipeCardView(product: product) { product, liked in
                        if let email = userAuth.email {
                            handleSwipe(product: product, liked: liked, email: email)
                        } else {
                            errorMessage = "Not logged in"
                        }
                    }
                    .zIndex(Double(unprocessedProducts.count - index)) // Stack cards with decreasing zIndex
                }
            }
        }
        .padding()
        
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
    private func handleSwipe(product: Product, liked: Bool, email: String) {
            if let index = allProducts.firstIndex(of: product) {
                if liked {
                    Task {
                        await toggleLike(product: product, email: email)
                    }
                } else {
                    Task {
                        await toggleDislike(product: product, email: email)
                    }
                }
                allProducts.remove(at: index) // Remove swiped card from the stack
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
 TileStackView(selectedCategory: $selectedCategory, selectedBrand: Binding<"All">)
 }
 */
