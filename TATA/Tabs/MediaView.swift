//
//  MediaView.swift
//  TATA
//
//  Created by Theo on 8/20/26.
//

import SwiftUI
import Photos
import AVKit

struct MediaView: View {
    let asset: PHAsset

    var body: some View {
        if asset.mediaSubtypes.contains(.photoLive) {
            LivePhotoView(
                asset: asset
            )
        }
        else if asset.mediaType == .video {
            VideoView(
                asset: asset
            )
        }
        else {
            ImageView(
                asset: asset
            )
        }
    }
}


struct ImageView: View {
    let asset: PHAsset
    
    @State private var image:
        UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .task {
            PhotoService.shared.requestImage(
                asset: asset,
                size: CGSize(
                    width: 1200,
                    height: 1200
                )
            ) {
                image = $0
            }
        }
    }
}

struct VideoView: View {
    let asset: PHAsset

    @State private var player:
        AVPlayer?

    var body: some View {
        Group {
            if let player {
                VideoPlayer(
                    player: player
                )
                .onAppear {
                    player.play()
                }
            } else {
                ProgressView()
            }
        }
        .task {
            PhotoService.shared.requestVideo(
                asset: asset
            ) { avAsset in
                if let avAsset {
                    player =
                    AVPlayer(
                        playerItem:
                            AVPlayerItem(
                                asset: avAsset
                            )
                    )
                }
            }
        }
    }
}

struct LivePhotoView: View {
    let asset: PHAsset

    var body: some View {
        ImageView(
            asset: asset
        )
    }
}
