//
//  LoginView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @EnvironmentObject var userAuth: UserAuthentication
    @State private var showSignup = false
    
    var body: some View {
        VStack {
            if showSignup {
                SignupView(showSignup: $showSignup)
            } else {
                Text("Login")
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
                
                Button("Sign In") {
                    signIn(email: email, password: password)
                }
                .padding()
                Button("Create New User") {
                    showSignup = true
                }
                .padding()
            }
        }
        .padding()
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                // Handle the error
                self.errorMessage = error.localizedDescription
            } else {
                // Handle successful sign-in (e.g., navigate to home screen)
                print("User signed in: \(result?.user.email ?? "No email")")
                // You can navigate to the next screen here using a NavigationLink or other navigation methods
                self.errorMessage = "success"
                userAuth.isAuthenticated = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
