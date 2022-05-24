//
//  PhotoKitAdapter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//
import Foundation
import PhotosUI

class PhotoKitAdapter: NSObject, PHPhotoLibraryChangeObserver, ObservableObject {
    
    func startFetching() {
        PHPhotoLibrary.shared().register(self)
        let fetchResultOptions = PHFetchOptions()
        fetchResultOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: fetchResultOptions)

        fetchResult?.enumerateObjects { object, count, stop in
            self.photos.append(object)
        }
        self.collectionView.reloadData()
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: self.fetchResult!) else { return }
        DispatchQueue.main.async {
            self.fetchResult = changes.fetchResultAfterChanges
            self.photos = []
            self.fetchResult?.enumerateObjects { object, count, stop in
                self.photos.append(object)
            }
            self.collectionView.reloadData()
        }
    }
    

}
