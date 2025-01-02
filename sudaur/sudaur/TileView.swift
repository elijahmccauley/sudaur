//
//  TileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/1/25.
//

import SwiftUI

struct TileView: View {
    var body: some View {
        VStack {
            Image("leon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            Text("ProductName")
            Text("amount?")
        }
        .background(Color.gray)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    TileView()
}
