//
//  BrowseView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI

struct BrowseView: View {
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    @State private var selectedCategory = "All"
    let categories = ["All", "Apparel", "Nutrition", "Recovery", "Other"]
    @EnvironmentObject var userAuth: UserAuthentication
    
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
                ForEach(0..<10) { index in
                    TileView()
                .frame(height: 200)
                }
            }
            .padding()
        }
    }
}

#Preview {
    BrowseView()
}
