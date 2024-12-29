//
//  SignupView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
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
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
                    
            Button(action: {
                        // Perform signup logic
                        // On success:
                userAuth.isAuthenticated = true
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
            }
        }
    }
}
