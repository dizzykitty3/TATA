import SwiftUI
import Photos

struct ImageView: View {
    let asset: PHAsset

    @State private var image: UIImage?

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
                size: CGSize(width: 1200, height: 1200)
            ) {
                image = $0
            }
        }
    }
}
