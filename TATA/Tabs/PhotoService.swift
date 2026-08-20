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
        let options = PHImageRequestOptions()

        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        manager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { image, _ in
            completion(image)
        }
    }

    func requestVideo(
        asset: PHAsset,
        completion: @escaping (AVAsset?) -> Void
    ) {
        let options = PHVideoRequestOptions()

        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true

        manager.requestAVAsset(
            forVideo: asset,
            options: options
        ) { avAsset, _, _ in
            completion(avAsset)
        }
    }

    func delete(
        asset: PHAsset,
        completion: @escaping (Bool) -> Void
    ) {
        PHPhotoLibrary.shared()
            .performChanges {
                PHAssetChangeRequest
                    .deleteAssets(
                        [asset] as NSArray
                    )
            } completionHandler: { success, _ in
                completion(success)
            }
    }

    func preload(
        assets: [PHAsset]
    ) {
        manager.startCachingImages(
            for: assets,
            targetSize: CGSize(
                width: 1000,
                height: 1000
            ),
            contentMode: .aspectFit,
            options: nil
        )
    }
}
