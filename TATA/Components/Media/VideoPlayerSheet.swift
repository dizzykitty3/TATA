import SwiftUI
import Photos
import AVKit
import UIKit

struct VideoPlayerSheet: View {
    let asset: PHAsset

    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let player {
                PlayerLayerView(player: player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        player.play()
                    }
            } else {
                ProgressView()
            }
        }
        .task {
            PhotoService.shared.requestVideo(asset: asset) { avAsset in
                if let avAsset {
                    player = AVPlayer(
                        playerItem: AVPlayerItem(asset: avAsset)
                    )
                }
            }
        }
    }
}

struct PlayerLayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerContainerView {
        let view = PlayerContainerView()
        view.playerLayer.player = player
        return view
    }

    func updateUIView(
        _ uiView: PlayerContainerView,
        context: Context
    ) {
        uiView.playerLayer.player = player
    }
}

final class PlayerContainerView: UIView {
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
