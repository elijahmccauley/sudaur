//
//  BrowseView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI
import FirebaseFirestore

struct BrowseView: View {
    let db = Firestore.firestore()
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    @State private var selectedCategory = "All"
    let categories = ["All", "Apparel", "Nutrition", "Recovery", "Other"]
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var errorMessage = ""
    @State private var allProducts: [Product] = []
    var body: some View {
        Text("Browse!")
        HStack {
            Text(" Filters ")
                .border(Color.black)
                .padding()
            Text(" Brand ")
                .border(Color.black)
                .padding()
            Picker("Filter", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .border(Color.black)
        }
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredData()) { product in
                    TileView(product: product)
                .frame(height: 200)
                }
            }
            .padding()
        }
        Spacer()
        .task {
            await fetchTileData()
        }
        
    }
    func filteredData() -> [Product] {
        if selectedCategory == "All" {
            return allProducts
        } else {
            return allProducts.filter { $0.category as? String == selectedCategory }
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
}

struct Product: Identifiable {
    var id: String // Document ID from Firestore
    var brand: String
    var product: String
    var category: String
    var amount: String
}

#Preview {
    BrowseView()
}
