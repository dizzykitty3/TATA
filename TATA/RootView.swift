//
//  RootView.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            ContentView()
        } else {
            OnboardingView()
        }
    }
}
