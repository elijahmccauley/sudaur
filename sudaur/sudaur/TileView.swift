//
//  TileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/1/25.
//

import SwiftUI

struct TileView: View {
    let product: Product
    @State private var isFlipped = false
    var body: some View {
        ZStack {
            if !isFlipped {
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
            if isFlipped {
                VStack {
                    Text(product.description as String)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .background(Color.gray)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0),
                          axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.6), value: isFlipped)
        .onTapGesture {
            isFlipped.toggle()
        }
    }
}

#Preview {
    TileView(product: Product(id: "abc", brand: "nike", product: "pegs", category: "apparel", amount: "2", description: "product description"))
}
