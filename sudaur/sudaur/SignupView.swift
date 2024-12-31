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


struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var name = ""
    @State private var school = ""
    @State private var gender = ""
    @State private var sport = ""
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
            TextField("Gender", text: $gender)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            TextField("Sport", text: $sport)
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

                    }
            else{
                print("User created successfully: \(authResult?.user.email ?? "")")
                userAuth.isAuthenticated = true
            }
        }
        
    }
}
