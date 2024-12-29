//
//  MainView.swift
//  sudaur
//
//  Created by Elijah McCauley on 12/29/24.
//

import SwiftUI

struct MainView: View {
    @Binding var activeView: ActiveView
    @EnvironmentObject var userAuth: UserAuthentication
    
    var body: some View {
        VStack {
            Text("Sudaur")
            Spacer()
            switch activeView {
                        case .feed:
                            FeedView()
                        case .browse:
                            BrowseView()
                        case .profile:
                            ProfileView()
                        }

            Spacer()
            NavBarView(activeView: $activeView)

        }
        .padding()
    }
}

