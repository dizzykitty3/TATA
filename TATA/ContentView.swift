import SwiftUI

struct ContentView: View {
    private enum AppTab: Hashable {
        case swipe
        case date
        case albums
        case settings
    }

    @StateObject
    private var deletionManager: DeletionManager

    @StateObject
    private var swipeModel: SwipeViewModel

    @State private var isShowingPendingDeletions = false
    @State private var selectedTab: AppTab = .swipe

    init() {
        let deletionManager = DeletionManager()
        _deletionManager = StateObject(wrappedValue: deletionManager)
        _swipeModel = StateObject(
            wrappedValue: SwipeViewModel(
                deletionManager: deletionManager
            )
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                Tab("Swipe", systemImage: "hand.draw", value: .swipe) {
                    SwipeView(
                        model: swipeModel
                    )
                }

                Tab("Date", systemImage: "calendar", value: .date) {
                    EmptyView()
                }

                Tab("Albums", systemImage: "photo.stack", value: .albums) {
                    EmptyView()
                }

                Tab("Settings", systemImage: "gearshape", value: .settings) {
                    SettingsView()
                }
            }

            if selectedTab == .swipe,
               !deletionManager.pendingAssets.isEmpty {
                HStack(spacing: 8) {
                    Button {
                        swipeModel.undoLastDeletion()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.title3)
                            .frame(
                                width: PendingDeletionLayout.buttonHeight,
                                height: PendingDeletionLayout.buttonHeight
                            )
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .accessibilityLabel("Undo Last Deletion")

                    Button {
                        isShowingPendingDeletions = true
                    } label: {
                        Text(
                            "Pending Deletions (\(deletionManager.pendingAssets.count))"
                        )
                        .font(.subheadline.weight(.semibold))
                        .frame(
                            height: PendingDeletionLayout.buttonHeight
                        )
                    }
                    .padding(.horizontal, 14)
                    .buttonStyle(.glass)
                    .buttonBorderShape(.capsule)
                    .accessibilityLabel("Pending Deletions")
                }
                .frame(height: PendingDeletionLayout.buttonHeight)
                .padding(.bottom, PendingDeletionLayout.buttonBottomInset)
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
