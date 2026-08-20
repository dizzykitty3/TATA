import SwiftUI
import Photos

struct MediaView: View {
    let asset: PHAsset
    var isCurrent = false

    var body: some View {
        if asset.mediaSubtypes.contains(.photoLive) {
            LivePhotoView(asset: asset)
        } else if asset.mediaType == .video {
            VideoThumbnailView(asset: asset, isCurrent: isCurrent)
        } else {
            ImageView(asset: asset)
        }
    }
}

struct LivePhotoView: View {
    let asset: PHAsset

    var body: some View {
        ImageView(asset: asset)
    }
}
