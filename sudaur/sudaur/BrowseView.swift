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
    @State private var likedProducts: [Product] = []
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
                        .onTapGesture {
                            toggleLike(product: product)
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
    func toggleLike(product: Product) {
        if let index = likedProducts.firstIndex(of: product) {
            likedProducts.remove(at: index) // Unlike if already liked
        } else {
            likedProducts.append(product) // Add to liked products
        }
    }
}

struct Product: Identifiable, Equatable {
    var id: String // Document ID from Firestore
    var brand: String
    var product: String
    var category: String
    var amount: String
}

#Preview {
    BrowseView()
}
