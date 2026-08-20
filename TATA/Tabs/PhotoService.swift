//
//  PhotoService.swift
//  TATA
//
//  Created by Theo on 8/20/26.
//

import Foundation
import Photos
import SwiftUI
import AVKit

final class PhotoService {
    static let shared = PhotoService()

    private let manager = PHCachingImageManager()

    private var cachedAssets: [PHAsset] = []

    private let imageCache = NSCache<NSString, UIImage>()
    private let videoCache = NSCache<NSString, AVAsset>()

    private init() {}

    func fetchAssets() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()

        options.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false
            )
        ]

        return PHAsset.fetchAssets(
            with: options
        )
    }

    func requestImage(
        asset: PHAsset,
        size: CGSize,
        completion: @escaping (UIImage?) -> Void
    ) {
        let cacheKey = asset.localIdentifier as NSString

        if let image = imageCache.object(forKey: cacheKey) {
            completion(image)
            return
        }

        let options = PHImageRequestOptions()

        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        manager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { image, _ in
            if let image {
                self.imageCache.setObject(image, forKey: cacheKey)
            }
            completion(image)
        }
    }

    func requestVideo(
        asset: PHAsset,
        completion: @escaping (AVAsset?) -> Void
    ) {
        let cacheKey = asset.localIdentifier as NSString

        if let avAsset = videoCache.object(forKey: cacheKey) {
            completion(avAsset)
            return
        }

        let options = PHVideoRequestOptions()

        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true

        manager.requestAVAsset(
            forVideo: asset,
            options: options
        ) { avAsset, _, _ in
            if let avAsset {
                self.videoCache.setObject(avAsset, forKey: cacheKey)
            }
            completion(avAsset)
        }
    }

    func delete(
        assets: [PHAsset],
        completion: @escaping (Bool) -> Void
    ) {
        PHPhotoLibrary.shared()
            .performChanges {
                PHAssetChangeRequest
                    .deleteAssets(
                        assets as NSArray
                    )
            } completionHandler: { success, _ in
                completion(success)
            }
    }

    func preload(
        assets: [PHAsset]
    ) {
        let targetSize = CGSize(
            width: 1200,
            height: 1200
        )

        manager.stopCachingImages(
            for: cachedAssets,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: nil
        )

        manager.startCachingImages(
            for: assets,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: nil
        )

        cachedAssets = assets

        for asset in assets {
            requestImage(
                asset: asset,
                size: targetSize
            ) { _ in }

            if asset.mediaType == .video {
                requestVideo(asset: asset) { _ in }
            }
        }
    }
}
