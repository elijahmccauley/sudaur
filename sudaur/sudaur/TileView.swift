//
//  TileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/1/25.
//

import SwiftUI

struct TileView: View {
    @State private var productName = "p"
    @State private var amount = "a"
    var body: some View {
        VStack {
            Image("leon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            Text(productName)
            //.padding([.top], 10)
            //    .font(.system(size: 20))
            Text(amount)
            //    .padding([.bottom], 20)
            //    .font(.system(size: 20))
        }
        .background(Color.gray)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    TileView()
}
