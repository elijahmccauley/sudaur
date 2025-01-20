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
        HStack(alignment: .center) {
            Spacer()
            Button(action: {
                activeView = .feed
            }) {
                Text("Feed")
            }
            
            
            Spacer()
            Button(action: {
                activeView = .browse
            }) {
                Text("Browse")
            }
            Spacer()
            Button(action: {
                activeView = .profile
            }) {
                Text("Profile")
            }
            Spacer()
        }
        
    }
}


