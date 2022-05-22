//
//  PhotoKitAdapter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//

import Foundation
import PhotosUI





class PhotoKitAdapter: NSObject, PHPhotoLibraryChangeObserver, ObservableObject {
    
    var allPhotos: PHFetchResult<PHAsset>?
    var images = [UIImage]()
    
    override init(){
        super.init()
        startFetching()
        
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changeResults = changeInstance.changeDetails(for: self.allPhotos!) {
                self.allPhotos = changeResults.fetchResultAfterChanges
                self.updateImages()
                self.objectWillChange.send()
            }
        }
        print("did change: \(self.images.count)")
    }
    
    fileprivate func updateImages() {
        self.images = []
        if let allPhotos = allPhotos {
            for index in 0 ..< allPhotos.count {
                let photo = allPhotos[index]
                appendImage(photo)
            }
        }
        print("updateImg: \(self.images.count)")
    }
    
    func startFetching() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        PHPhotoLibrary.shared().register(self)
        self.updateImages()
    }
    
    fileprivate func appendImage(_ photo: PHAsset) {
        // This actually appends multiple copies of the image because
        // it gets called multiple times for the same asset.
        // Proper tracking of the asset needs to be implemented
        let photoManager = PHImageManager.default()
        if photo.mediaType == .image {
            photoManager.requestImage(for: photo, targetSize: CGSize(width: 1024, height: 768), contentMode: .default, options: nil) { image, _ in
                if let image = image {
                    self.images.append(image)
                    self.objectWillChange.send()
                }
            }
        }
    }
}

