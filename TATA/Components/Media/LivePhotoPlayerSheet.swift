import SwiftUI
import Photos
import PhotosUI
import UIKit

struct LivePhotoPlayerSheet: View {
    let asset: PHAsset

    @State private var livePhoto: PHLivePhoto?

    private var aspectRatio: CGFloat {
        guard asset.pixelHeight > 0 else {
            return 1
        }
        return CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
    }

    var body: some View {
        Group {
            if let livePhoto {
                GeometryReader { proxy in
                    let containerRatio = proxy.size.width / proxy.size.height
                    let fittedSize: CGSize = {
                        if aspectRatio > containerRatio {
                            let width = proxy.size.width
                            return CGSize(
                                width: width,
                                height: width / aspectRatio
                            )
                        } else {
                            let height = proxy.size.height
                            return CGSize(
                                width: height * aspectRatio,
                                height: height
                            )
                        }
                    }()

                    LivePhotoPlayerView(livePhoto: livePhoto)
                        .frame(
                            width: fittedSize.width,
                            height: fittedSize.height
                        )
                        .position(
                            x: proxy.size.width / 2,
                            y: proxy.size.height / 2
                        )
                }
            } else {
                ProgressView()
            }
        }
        .task {
            PhotoService.shared.requestLivePhoto(asset: asset) {
                livePhoto = $0
            }
        }
    }
}

struct LivePhotoPlayerView: UIViewRepresentable {
    let livePhoto: PHLivePhoto

    func makeUIView(context: Context) -> PHLivePhotoView {
        let view = PHLivePhotoView()
        view.livePhoto = livePhoto
        DispatchQueue.main.async {
            view.startPlayback(with: .full)
        }
        return view
    }

    func updateUIView(
        _ uiView: PHLivePhotoView,
        context: Context
    ) {
        uiView.livePhoto = livePhoto
    }
}
