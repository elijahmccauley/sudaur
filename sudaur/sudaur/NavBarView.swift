//
//  NavBarView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI

struct NavBarView: View {
    @Binding var activeView: ActiveView
    var body: some View {
        HStack {
            Button(action: {
                activeView = .home
            }) {
                Text("Home")
            }
            Spacer()
            Button(action: {
                activeView = .messages
            }) {
                Text("Messages")
            }
            Spacer()
            Button(action: {
                activeView = .profile
            }) {
                Text("Profile")
            }
        }
        
    }
}


