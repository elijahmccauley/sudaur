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
    @State private var selectedBrand = "All"
    let categories = ["All", "Apparel", "Nutrition", "Recovery", "Other"]
    
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var errorMessage = ""
    @State private var allProducts: [Product] = []
    var brands: [String] {
            let allBrands = allProducts.map { $0.brand }
            let uniqueBrands = Set(allBrands)
            return ["All"] + uniqueBrands.sorted()
    }
    var body: some View {
        Text("Browse!")
        HStack {
            Spacer()
            Text(" Filters ")
                .border(Color.black)
                .padding()
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
