//
//  ProfileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    let db = Firestore.firestore()
    @State private var documentData: [String: Any]? = nil
    @State private var errorMessage: String? = nil
    @State private var activeView: ActiveView = .profile
    @State private var newBio = ""
    @EnvironmentObject var userAuth: UserAuthentication
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                VStack {
                    
                    if let data = documentData {
                        Text(data["name"] as? String ?? "Name")
                            .padding()
                        Text(data["school"] as? String ?? "School")
                            .padding()
                        Text(data["sport"] as? String ?? "Sport/Position")
                            .padding()
                    } else {
                        Text("Loading...")
                    }
                }
            }
            Text("Bio")
            if let data = documentData {
                if "" == data["bio"] as? String ?? "Bio"{
                    TextField("Add a Bio", text: $newBio)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                } else {
                    Text(data["bio"] as? String ?? "Bio")
                }
                
            } else {
                Text("Loading...")
            }
            Spacer()
            Text("Athlete Profile")
                .font(.title)
                .padding()
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Spacer()
            
            
        }
        .navigationTitle("profile")
        .padding()
        .task {
            if let email = userAuth.email {
                await fetchUserData(email: email)
            } else {
                errorMessage = "not logged in"
            }
            
        }
        
    }
    func fetchUserData(email: String) async {
            let docRef = db.collection("users").document(email)
            do {
                let document = try await docRef.getDocument()
                if document.exists {
                    documentData = document.data()
                } else {
                    errorMessage = "Document does not exist"
                }
            } catch {
                errorMessage = error.localizedDescription
            }
    }
}


