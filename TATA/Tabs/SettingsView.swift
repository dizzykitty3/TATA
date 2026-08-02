//
//  SettingsView.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    #if DEBUG
                    Button("Reset Onboarding") {
                        hasCompletedOnboarding = false
                    }
                    #endif
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
