//
//  PhotoKitAdapter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//
import Foundation
import PhotosUI

// FIXME: Optimize, remove hardcode
class PhotoKitAdapter {//: NSObject, PHPhotoLibraryChangeObserver, ObservableObject {

    var presenter: SelectedPhotosPresenterInputProtocol?
    
//    override init() {
//        super.init()
//        
//    }
    
    // FIXME: - is it necessary?
//    func startFetching() {
//        let fetchResultOptions = PHFetchOptions()
//        fetchResultOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        var photos = [UIImage?]()
//        DispatchQueue.main.async {
//            let fetchResult = PHAsset.fetchAssets(with: fetchResultOptions)
//            fetchResult.enumerateObjects { asset, count, stop in
//                let photo = self.getImage(asset: asset)
//                photos.append(photo)
//            }
//            self.presenter?.setPhotos(photos: photos, fetchResult: fetchResult)
//        }
//    }
//
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        guard let presenter = presenter else { return }
//
//        var photos = presenter.getPhotos()
//        var fetchResult = presenter.getFetchResult()
//
//        guard let changes = changeInstance.changeDetails(for: fetchResult!) else { return }
//        if !changes.hasIncrementalChanges { return }
//
//        DispatchQueue.main.async {
//            fetchResult = changes.fetchResultAfterChanges
//            if let removeIndexes = changes.removedIndexes {
//                for removeIndex in removeIndexes {
//                    photos.remove(at: removeIndex)
//                }
//            }
//            if let insertIndexes = changes.insertedIndexes {
//                for insertIndex in insertIndexes {
//                    guard let asset = fetchResult?[insertIndex] else { return }
//                    let image = self.getImage(asset: asset)
//                    photos.insert(image, at: insertIndex)
//                }
//            }
//            if let changedIndexes = changes.changedIndexes {
//                for changedIndex in changedIndexes {
//                    guard let asset = fetchResult?[changedIndex] else { return }
//                    photos[changedIndex] = self.getImage(asset: asset)
//                }
//            }
//            changes.enumerateMoves { fromIndex, toIndex in
//                guard let asset = fetchResult?[toIndex] else { return }
//                photos.remove(at: fromIndex)
//                let image = self.getImage(asset: asset)
//                photos.insert(image, at: toIndex)
//            }
//            print(photos.count)
//            presenter.setPhotos(photos: photos, fetchResult: fetchResult)
//        }
//    }
//
//    private func getImage(asset: PHAsset) -> UIImage? {
//        let manager = PHImageManager.default()
//        var photo: UIImage?
//        let _ = manager.requestImage(for: asset,
//                                     targetSize: CGSize(width: 400, height: 400),
//                                     contentMode: .aspectFit, options: nil) { image, _ in
//            photo = image
//        }
//        return photo
//    }

}
