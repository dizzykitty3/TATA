import SwiftUI

struct ContentView: View {
    @StateObject
    private var deletionManager = DeletionManager()

    @State private var isShowingPendingDeletions = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                Tab("Swipe", systemImage: "hand.draw") {
                    SwipeView(deletionManager: deletionManager)
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
                    Text(
                        "Pending Deletions (\(deletionManager.pendingAssets.count))"
                    )
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 58)
            }
        }
        .sheet(isPresented: $isShowingPendingDeletions) {
            PendingDeletionSheet(deletionManager: deletionManager)
        }
    }
}

#Preview {
    ContentView()
}
