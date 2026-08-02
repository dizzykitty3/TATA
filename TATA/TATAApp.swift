//
//  TATAApp.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI

@main
struct TATAApp: App {
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
