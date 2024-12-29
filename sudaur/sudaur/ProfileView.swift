//
//  ProfileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var activeView: ActiveView = .profile
    @EnvironmentObject var userAuth: UserAuthentication
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                VStack {
                    Text("Name")
                    Text("School")
                    Text("Sport/Position")
                }
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
        
    }
}

#Preview {
    ProfileView()
}
