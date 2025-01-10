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
    @State private var isEditing = false
    @State private var name = ""
    @State private var school = ""
    @State private var sport = ""
    @State private var gender = ""
    @State private var bio = ""
    @EnvironmentObject var userAuth: UserAuthentication
    var body: some View {
        VStack {
            if let data = documentData {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Name:")
                        if isEditing {
                            TextField("Enter your name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(data["name"] as? String ?? "Name")
                        }
                    }
                    .padding()

                    HStack {
                        Text("School:")
                        if isEditing {
                            TextField("Enter your school", text: $school)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(data["school"] as? String ?? "School")
                        }
                    }
                    .padding()

                    HStack {
                        Text("Sport/Position:")
                        if isEditing {
                            TextField("Enter your sport/position", text: $sport)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(data["sport"] as? String ?? "Sport/Position")
                        }
                    }
                    .padding()
                    
                    HStack {
                        Text("Bio:")
                        if isEditing {
                            TextField("Enter your bio", text: $bio)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(data["bio"] as? String ?? "Bio")
                        }
                    }
                    .padding()
                }
            } else {
                Text("Loading...")
            }

            Spacer()

            HStack {
                Button(action: {
                    isEditing.toggle()
                    if !isEditing, let email = userAuth.email {
                        updateUserProfile(email: email)
                    }
                }) {
                    Text(isEditing ? "Save" : "Edit Profile")
                        .padding()
                        .background(isEditing ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                if isEditing {
                    Button(action: {
                        isEditing = false
                        resetFields()
                    }) {
                        Text("Cancel")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
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
                    // Initialize local fields with fetched data
                    name = documentData?["name"] as? String ?? ""
                    school = documentData?["school"] as? String ?? ""
                    sport = documentData?["sport"] as? String ?? ""
                    bio = documentData?["bio"] as? String ?? ""
                } else {
                    errorMessage = "Document does not exist"
                }
            } catch {
                errorMessage = error.localizedDescription
            }
    }
    func resetFields() {
        // Reset editing fields to the original values from Firestore
        name = documentData?["name"] as? String ?? ""
        school = documentData?["school"] as? String ?? ""
        sport = documentData?["sport"] as? String ?? ""
        bio = documentData?["bio"] as? String ?? ""
    }
    func updateUserProfile(email: String) {
        let updatedData: [String: Any] = [
            "name": name,
            "school": school,
            "sport": sport,
            "bio": bio
        ]
        db.collection("users").document(email).setData(updatedData, merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
                if let email = userAuth.email {
                    Task {
                        await fetchUserData(email: email) // Refresh the profile view
                    }
                }
            }
        }
    }
    func updateBio(bio: String, email: String) {
        db.collection("users").document(email).setData([
            "bio": bio
        ], merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
                
            } else {
                print("Document successfully written!")
                
            }
        }
    }
}


