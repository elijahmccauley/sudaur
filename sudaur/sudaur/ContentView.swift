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
    case browse
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
                        case .browse:
                            BrowseView()
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
