import SwiftUI
import Photos

struct VideoThumbnailView: View {
    let asset: PHAsset
    let isCurrent: Bool

    @State private var isShowingPlayer = false

    var body: some View {
        ZStack {
            ImageView(asset: asset)

            if isCurrent {
                Button {
                    isShowingPlayer = true
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 64))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                        .shadow(
                            color: .black.opacity(0.4),
                            radius: 8
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $isShowingPlayer) {
            NavigationStack {
                VideoPlayerSheet(asset: asset)
                    .navigationTitle("Video Playback")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
