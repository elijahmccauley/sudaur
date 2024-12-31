//
//  FeedView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var userAuth: UserAuthentication
    @Binding var activeView: ActiveView
    var body: some View {
        
        Text("Feed!")
        Spacer()
    }
}

struct MessageView: View {
    @EnvironmentObject var userAuth: UserAuthentication
    var body: some View {
        List {
            Text("message1")
            Text("message2")
        }
    }
}

