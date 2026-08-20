//
//  SwipeViewModel.swift
//  TATA
//
//  Created by Theo on 8/20/26.
//

import Foundation
import Photos
import Combine

@MainActor
final class SwipeViewModel: ObservableObject {
    private let service = PhotoService.shared

    private let preloadCount = 5

    // Keep a local snapshot so deleting the current asset cannot make the
    // next asset's index shift underneath us.
    private var assets: [PHAsset]

    private var index = 0

    @Published
    var current: PHAsset?

    @Published
    var next: PHAsset?

    @Published
    var previous: PHAsset?

    init() {
        let fetchResult = service.fetchAssets()
        assets = (0..<fetchResult.count).map {
            fetchResult.object(at: $0)
        }
        load(index: 0)
    }

    func load(index: Int) {
        guard index >= 0, index < assets.count else {
            current = nil
            next = nil
            previous = nil
            return
        }

        self.index = index

        current = assets[index]

        if index > 0 {
            previous = assets[index - 1]
        } else {
            previous = nil
        }

        if index + 1 < assets.count {
            next = assets[index + 1]
        } else {
            next = nil
        }

        // Keep a small, bounded cache window around the current item. The
        // order prioritizes both directions and never exceeds five assets.
        let assetsToPreload = (1...preloadCount)
            .flatMap { distance in
                [index + distance, index - distance]
            }
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

        load(
            index: index + 1
        )
    }

    func movePrevious() {
        guard index > 0 else {
            return
        }

        load(
            index: index - 1
        )
    }

    func deleteCurrent(
        completion: @escaping () -> Void
    ) {
        guard let current else {
            return
        }

        service.delete(
            asset: current
        ) { success in
            Task { @MainActor in
                guard success else {
                    completion()
                    return
                }

                if let deletedIndex = self.assets.firstIndex(
                    where: { $0.localIdentifier == current.localIdentifier }
                ) {
                    self.assets.remove(at: deletedIndex)
                }

                // The item that was after the deleted asset now occupies the
                // same index. At the end, load() clears the current item.
                self.load(index: self.index)
                completion()
            }
        }
    }
}
