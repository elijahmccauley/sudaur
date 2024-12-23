//
//  ContentView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Sudaur")
            Spacer()
            HStack (alignment: .bottom) {
                Spacer()
                Image(systemName: "house")
                    .imageScale(.large)
                Spacer()
                Image(systemName: "message")
                    .imageScale(.large)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .imageScale(.large)
                Spacer()
                
            }
        }
        .padding()
        
        
    }
}

#Preview {
    ContentView()
}
