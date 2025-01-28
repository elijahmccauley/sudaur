//
//  NewProduct.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/6/25.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

struct NewProduct: View {
    let db = Firestore.firestore()
    let categories = ["Nutrition","Recovery","Apparel","Other"]
    @State private var brand = ""
    @State private var product = ""
    @State private var amount = ""
    @State private var description = ""
    @State private var selectedCategory = "Nutrition"
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        Text("Add a New Product")
        TextField("Brand", text: $brand)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
        TextField("Product", text: $product)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
        TextField("Amount", text: $amount)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
        TextField("Description", text: $description)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
        Picker("Category", selection: $selectedCategory) {
            ForEach(categories, id: \.self) { category in Text(category).tag(category)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .border(Color.black)
        if !errorMessage.isEmpty {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
        if !successMessage.isEmpty {
            Text(successMessage)
                .foregroundColor(.red)
                .padding()
        }
        
        Button(action: {
            createProduct(brand: brand, product: product, amount: amount, category: selectedCategory, description: description)
        }) {
            Text("Create")
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    func createProduct(brand: String, product: String, amount: String, category: String, description: String) {
        db.collection("products").document().setData([
            "brand": brand,
            "product": product,
            "category": category,
            "amount": amount,
            "description": description
            ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
                successMessage = ""
            } else {
                print("Document successfully written!")
                successMessage = "Success"
            }
        }
    }
}

#Preview {
    NewProduct()
}
