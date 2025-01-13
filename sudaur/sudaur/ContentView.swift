//
//  ContentView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

enum ActiveView {
    case feed
    case browse
    case profile
    case messages
    case activity
    case settings
}
class UserAuthentication: ObservableObject {
    @Published var isAuthenticated = false
    @Published var email: String?
}

struct User: Identifiable, Codable {
    var id: String { email }
    var email: String
    var name: String?
    var sport: String?
    var school: String?
    var gender: String?
    var bio: String?
    var ighandle: String?
    var likedProducts: [String]?
}

struct ContentView: View {
    let db = Firestore.firestore()
    
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
