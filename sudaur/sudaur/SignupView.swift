//
//  SignupView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore


struct SignupView: View {
    let db = Firestore.firestore()
    let genders = ["M", "F"]
    let sports = ["Cross Country", "Track and Field", "Football", "Basketball", "Baseball", "Volleyball", "Softball", "Soccer", "Lacrosse"]
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var name = ""
    @State private var school = ""
    @State private var ighandle = ""
    @State private var selectedGender = "M"
    @State private var selectedSport = "Cross Country"
    @Binding var showSignup: Bool
    @EnvironmentObject var userAuth: UserAuthentication
    var body: some View {
        VStack {
            Text("Signup")
                .font(.largeTitle)
                .padding()
            
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Name", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            TextField("School", text: $school)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            Picker("Gender", selection: $selectedGender) {
                ForEach(genders, id: \.self) { gender in Text(gender).tag(gender)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .border(Color.black)
            Picker("Sport", selection: $selectedSport) {
                ForEach(sports, id: \.self) { sport in Text(sport).tag(sport)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .border(Color.black)
            TextField("Instagram Handle", text: $ighandle)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
                    
            Button(action: {
                        // Perform signup logic
                        // On success:
                createUser(email: email, password: password)
            }) {
                Text("Signup")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
                    
            Button(action: {
                showSignup = false
            }) {
                Text("Already have an account? Log in")
                    .padding()
            }
        }
    }
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // ...
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                print("User created successfully: \(authResult?.user.email ?? "")")
                db.collection("users").document(email).setData([
                    "name": name,
                    "sport": selectedSport,
                    "school": school,
                    "gender": selectedGender,
                    "bio": "",
                    "ighandle": ighandle,
                    "likedProducts": []
                ]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                userAuth.email = email
                userAuth.isAuthenticated = true
            }
        }
        
    }
}
