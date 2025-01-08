//
//  TileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/1/25.
//

import SwiftUI

struct TileView: View {
    let product: Product
    var body: some View {
        VStack {
            Image("leon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            Text(product.brand as String)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(product.amount as String)
                .font(.headline)
                .multilineTextAlignment(.center)
            //    .padding([.bottom], 20)
            //    .font(.system(size: 20))
        }
        .background(Color.gray)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    TileView(product: Product(id: "abc", brand: "nike", product: "pegs", category: "apparel", amount: "2"))
}
