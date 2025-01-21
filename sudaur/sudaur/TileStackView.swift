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
    var body: some View {
        ZStack {
            ForEach(allProducts, id: \.id) { product in
                if let index = allProducts.firstIndex(where: { $0.id == product.id }) {
                    SwipeCardView(product: product, onSwipe: handleSwipe)
                        .zIndex(Double(allProducts.count - index)) // Stack cards with decreasing zIndex
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
    private func handleSwipe(product: Product, liked: Bool) {
        if let index = allProducts.firstIndex(of: product) {
            if liked {
                likedProducts.append(product)
            } else {
                dislikedProducts.append(product)
            }
            allProducts.remove(at: index) // Remove swiped card from the stack
        }
    }
}

#Preview {
    TileStackView()
}
