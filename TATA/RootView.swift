//
//  RootView.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI
import Photos

struct RootView: View {
    @State private var photoAuthorizationStatus =
        PHPhotoLibrary.authorizationStatus(for: .readWrite)

    var body: some View {
        Group {
            switch photoAuthorizationStatus {
            case .authorized, .limited:
                ContentView()

            default:
                OnboardingView()
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification
            )
        ) { _ in
            updateAuthorizationStatus()
        }
    }

    private func updateAuthorizationStatus() {
        photoAuthorizationStatus =
            PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
}
