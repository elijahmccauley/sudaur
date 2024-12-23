//
//  ProfileView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/23/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Athlete Profile")
                .font(.title)
                .padding()
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
        }
        .navigationTitle("profile")
        .padding()
        
    }
}

#Preview {
    ProfileView()
}
