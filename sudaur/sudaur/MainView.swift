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
            HStack {
                Text("Sudaur")
                switch activeView {
                case .feed:
                    Button(action: {
                        activeView = .activity
                    }) {
                        Text("Activity")
                    }
                    Button(action: {
                        activeView = .messages
                    }) {
                        Text("Messages")
                    }
                case .profile:
                    Button(action: {
                        activeView = .swipe
                    }) {
                        Text("Settings")
                    }
                default:
                    Text("")
                    
                }
            }
            Spacer()
            switch activeView {
                case .feed:
                    FeedView(activeView: $activeView)
                case .browse:
                    BrowseView()
                case .profile:
                    ProfileView()
                case .messages:
                    MessageView()
                case .activity:
                    ActivityView()
                case .settings:
                    SettingsView()
                case .swipe:
                    SettingsView()
            }

            Spacer()
            NavBarView(activeView: $activeView)

        }
        .padding()
    }
}

