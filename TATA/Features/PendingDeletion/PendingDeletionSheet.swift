import SwiftUI
import Photos

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
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(
                            deletionManager.pendingAssets,
                            id: \.localIdentifier
                        ) { asset in
                            MediaView(asset: asset, showsPlaybackButton: true)
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

        deletionManager.deleteAll { result in
            isDeleting = false

            switch result {
            case .success:
                dismiss()
            case .cancelled:
                break
            case .failure:
                errorMessage = "The selected media could not be deleted."
            }
        }
    }
}
