import SwiftUI
import Photos

struct ImageView: View {
    let asset: PHAsset
    let targetSize: CGSize
    let contentMode: ContentMode

    @State private var image: UIImage?

    init(
        asset: PHAsset,
        targetSize: CGSize = PHImageManagerMaximumSize,
        contentMode: ContentMode = .fit
    ) {
        self.asset = asset
        self.targetSize = targetSize
        self.contentMode = contentMode
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                ProgressView()
            }
        }
        .task {
            PhotoService.shared.requestImage(
                asset: asset,
                size: targetSize
            ) {
                image = $0
            }
        }
    }
}
