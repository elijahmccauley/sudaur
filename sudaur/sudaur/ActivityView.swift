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
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var errorMessage = ""
    @State private var allProducts: [Product] = []
    @State private var likedProducts: [Product] = []
    @State private var documentData: [String: Any]? = nil
    @State private var userLikedProducts: [String] = []
    var body: some View {
        Text("Activity!")
        Text("Liked Products:")
        .font(.headline)
        .padding(.top)

        ScrollView(.horizontal) {
            HStack {
                ForEach(likedProducts, id: \.id) { product in
                    Text(product.brand)
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
                } else {
                    errorMessage = "Document does not exist"
                }
            } catch {
                errorMessage = error.localizedDescription
            }
    }
}

#Preview {
    ActivityView()
}
