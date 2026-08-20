//
//  ContentView.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Swipe", systemImage: "hand.draw") {
                SwipeView()
            }

            Tab("Date", systemImage: "calendar") {
                EmptyView()
            }

            Tab("Albums", systemImage: "photo.stack") {
                EmptyView()
            }

            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
