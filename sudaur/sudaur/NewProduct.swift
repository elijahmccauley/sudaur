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
    let category = ["Nutrition","Recovery","Apparel","Other"]
    @State private var brand = ""
    @State private var product = ""
    @State private var amount = 0
    @State private var selectedCategory = "Nutrition"

    var body: some View {
        Text("Add a New Product")
    }
}

#Preview {
    NewProduct()
}
