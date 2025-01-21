//
//  SwipeCardView.swift
//  sudaur
//
//  Created by Elijah McCauley on 1/20/25.
//

import SwiftUI

struct SwipeCardView: View {
    let product: Product
    let onSwipe: (Product, Bool) -> Void
    @State private var offset: CGSize = .zero
        @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
                    Image("leon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                    Text(product.brand)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text(product.amount)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
                .shadow(radius: 5)
                .offset(x: offset.width, y: offset.height)
                .rotationEffect(.degrees(rotation))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                            rotation = Double(offset.width / 10) // Adjust rotation based on drag
                        }
                        .onEnded { gesture in
                            if offset.width > 150 {
                                onSwipe(product, true) // Swiped right (like)
                            } else if offset.width < -150 {
                                onSwipe(product, false) // Swiped left (dislike)
                            } else {
                                offset = .zero // Reset position if not swiped far enough
                                rotation = 0
                            }
                        }
                )
                .animation(.spring(), value: offset)
        HStack {
            Button(action: {
                print("dislike")
            }) {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .padding(8)
            }
            Spacer()
            Button(action: {
                print("like")
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .padding(8)
            }
        }
    }
}
