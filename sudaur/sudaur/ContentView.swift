//
//  ContentView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI
import FirebaseAuth

enum ActiveView {
    case feed
    case browse
    case profile
}
class UserAuthentication: ObservableObject {
    @Published var isAuthenticated = false
}

struct ContentView: View {
    @StateObject private var userAuth = UserAuthentication()
    @State private var activeView: ActiveView = .feed


        var body: some View {
            VStack {
                if userAuth.isAuthenticated {
                    // Main View with Header and NavBar
                    MainView(activeView: $activeView)
                        .environmentObject(userAuth)
                } else {
                    // Show Login View
                    LoginView()
                        .environmentObject(userAuth)
                }
            }
        }
}

#Preview {
    ContentView()
}
