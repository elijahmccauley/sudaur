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
    @EnvironmentObject var userAuth: UserAuthentication
    var body: some View {
        Text("Browse!")
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
