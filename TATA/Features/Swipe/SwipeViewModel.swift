import Foundation
import Photos
import Combine

@MainActor
final class SwipeViewModel: ObservableObject {
    private let service = PhotoService.shared
    private let deletionManager: DeletionManager
    private let preloadCount = 5

    private var assets: [PHAsset]
    private var index = 0

    @Published
    var current: PHAsset?

    @Published
    var next: PHAsset?

    init(deletionManager: DeletionManager) {
        self.deletionManager = deletionManager

        let fetchResult = service.fetchAssets()
        let pendingIdentifiers = Set(
            deletionManager.pendingAssets.map(\.localIdentifier)
        )

        assets = (0..<fetchResult.count).map {
            fetchResult.object(at: $0)
        }.filter {
            !pendingIdentifiers.contains($0.localIdentifier)
        }

        load(index: 0)
    }

    func load(index: Int) {
        guard index >= 0, index < assets.count else {
            current = nil
            next = nil
            return
        }

        self.index = index
        current = assets[index]

        if index + 1 < assets.count {
            next = assets[index + 1]
        } else {
            next = nil
        }

        let assetsToPreload = (1...preloadCount)
            .map { index + $0 }
            .filter { $0 >= 0 && $0 < assets.count }
            .prefix(preloadCount)
            .map { assets[$0] }

        if !assetsToPreload.isEmpty {
            service.preload(assets: Array(assetsToPreload))
        }
    }

    func moveNext() {
        guard index + 1 < assets.count else {
            return
        }

        load(index: index + 1)
    }

    func markCurrentForDeletion() {
        guard let current else {
            return
        }

        deletionManager.add(current)

        if let deletedIndex = assets.firstIndex(
            where: { $0.localIdentifier == current.localIdentifier }
        ) {
            assets.remove(at: deletedIndex)
        }

        load(index: index)
    }
}
