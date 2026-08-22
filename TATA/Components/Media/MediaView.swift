import SwiftUI
import Photos

struct MediaView: View {
    let asset: PHAsset
    var showsPlaybackButton = false

    var body: some View {
        if asset.mediaSubtypes.contains(.photoLive) {
            LivePhotoView(asset: asset, showsPlaybackButton: showsPlaybackButton)
        } else if asset.mediaType == .video {
            VideoThumbnailView(asset: asset, showsPlaybackButton: showsPlaybackButton)
        } else {
            ImageView(asset: asset)
        }
    }
}

struct LivePhotoView: View {
    let asset: PHAsset
    let showsPlaybackButton: Bool

    @State private var isShowingPlayer = false

    var body: some View {
        ZStack {
            ImageView(asset: asset)

            if showsPlaybackButton {
                MediaPlayButton(title: "LivePhoto") {
                    isShowingPlayer = true
                }
            }
        }
        .sheet(isPresented: $isShowingPlayer) {
            NavigationStack {
                LivePhotoPlayerSheet(asset: asset)
                    .navigationTitle("Live Photo Playback")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
