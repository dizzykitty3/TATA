import Foundation
import Photos
import Combine

@MainActor
final class DeletionManager: ObservableObject {
    @Published
    private(set) var pendingAssets: [PHAsset] = []

    func add(_ asset: PHAsset) {
        guard !pendingAssets.contains(where: {
            $0.localIdentifier == asset.localIdentifier
        }) else {
            return
        }

        pendingAssets.append(asset)
    }

    func deleteAll(
        completion: @escaping (PhotoDeletionResult) -> Void
    ) {
        guard !pendingAssets.isEmpty else {
            completion(.success)
            return
        }

        PhotoService.shared.delete(assets: pendingAssets) { result in
            Task { @MainActor in
                if case .success = result {
                    self.pendingAssets.removeAll()
                }
                completion(result)
            }
        }
    }
}
