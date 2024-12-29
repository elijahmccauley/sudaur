//
//  ContentView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI
import FirebaseAuth

enum ActiveView {
    case home
    case profile
    case messages
}

struct ContentView: View {
    @State private var activeView: ActiveView = .home

    var body: some View {
        VStack {
            Text("Sudaur")
            Spacer()
            switch activeView {
                        case .home:
                            LoginView()
                        case .messages:
                            ProfileView()
                        case .profile:
                            ProfileView()
                        }

            Spacer()
            NavBarView(activeView: $activeView)

        }
        .padding()
        
        
    }
}

struct ProfileView2: View {
    var body: some View {
         NavigationView {
             List {
                 NavigationLink(destination: ContentView()) {
                     Text("Login")
                 }
             }
             .navigationBarTitle(Text("Master"))
         }
        
    }
}

#Preview {
    ContentView()
}
