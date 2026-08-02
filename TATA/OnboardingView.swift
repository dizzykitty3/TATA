//
//  OnboardingView.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundStyle(.tint)

            VStack(spacing: 12) {
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Allow access to your photo library\nso we can organize your memories.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
    }

}

#Preview {
    OnboardingView()
}
