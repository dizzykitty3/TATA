import SwiftUI
import Photos

struct VideoThumbnailView: View {
    let asset: PHAsset
    let showsPlaybackButton: Bool

    @State private var isShowingPlayer = false

    var body: some View {
        ZStack {
            ImageView(asset: asset)

            if showsPlaybackButton {
                MediaPlayButton(title: "Video") {
                    isShowingPlayer = true
                }
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
