//
//  ContentView.swift
//  TATA
//
//  Created by Theo on 8/2/26.
//

import SwiftUI
import Photos

struct ContentView: View {
    @StateObject
    private var deletionManager = DeletionManager()

    @State private var isShowingPendingDeletions = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                Tab("Swipe", systemImage: "hand.draw") {
                    SwipeView(
                        deletionManager: deletionManager
                    )
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

            if !deletionManager.pendingAssets.isEmpty {
                Button {
                    isShowingPendingDeletions = true
                } label: {
                    Text("Pending Deletions (\(deletionManager.pendingAssets.count))")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 58)
            }
        }
        .sheet(isPresented: $isShowingPendingDeletions) {
            PendingDeletionSheet(
                deletionManager: deletionManager
            )
        }
    }
}

struct PendingDeletionSheet: View {
    @ObservedObject
    var deletionManager: DeletionManager

    @Environment(\.dismiss)
    private var dismiss

    @State private var isDeleting = false
    @State private var errorMessage: String?

    private let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVGrid(
                        columns: columns,
                        spacing: 0
                    ) {
                        ForEach(
                            deletionManager.pendingAssets,
                            id: \.localIdentifier
                        ) { asset in
                            MediaView(
                                asset: asset,
                                isCurrent: false
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .clipped()
                        }
                    }
                    .padding(.vertical, 8)
                }

                Button {
                    deletePendingAssets()
                } label: {
                    Text("Delete")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .disabled(isDeleting)
                .padding(.bottom, 16)
            }
            .navigationTitle("Pending Deletions")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Unable to Delete",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Please try again.")
            }
        }
    }

    private func deletePendingAssets() {
        isDeleting = true

        deletionManager.deleteAll { success in
            isDeleting = false

            if success {
                dismiss()
            } else {
                errorMessage = "The selected media could not be deleted."
            }
        }
    }
}

#Preview {
    ContentView()
}
