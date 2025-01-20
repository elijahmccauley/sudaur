//
//  ActivityView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/31/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ActivityView: View {
    let db = Firestore.firestore()
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    let filters = ["Likes", "Matches", "Dislikes"]
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var errorMessage = ""
    @State private var allProducts: [Product] = []
    @State private var likedProducts: [Product] = []
    @State private var dislikedProducts: [Product] = []
    @State private var documentData: [String: Any]? = nil
    @State private var userLikedProducts: [String] = []
    @State private var userDislikedProducts: [String] = []
    @State private var selectedType = "Likes"
    
    var body: some View {
        Text("Activity!")
        HStack {
            Button(action: {
                selectedType = "Likes"
            }) {
                Text("Likes")
            }
            Spacer()
            Button(action: {
                selectedType = "Matches"
            }) {
                Text("Matches")
            }
            Spacer()
            Button(action: {
                selectedType = "Dislikes"
            }) {
                Text("Dislikes")
            }
        }
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredData()) { product in
                    TileView(product: product)
                        .frame(height: 200)
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
                            Image(systemName: "heart.fill")
                                .foregroundColor(.blue)
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
    func filteredData() -> [Product] {
        if selectedType == "Likes" {
            return likedProducts
        } else if selectedType == "Matches" {
            return allProducts
        } else {
            return dislikedProducts
        }
    }
}

#Preview {
    ActivityView()
}
