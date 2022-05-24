//
//  SelectedPhotosPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import Foundation
import Photos
import UIKit

protocol SelectedPhotosPresenterInputProtocol: AnyObject {
    init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol, model: SelectedPhotosModel, adapter: PhotoKitAdapter)
    func tapOnCloseButton(for view: UICollectionViewController)
    //func startFetching()
    func getPhotos() -> [UIImage?]
    func getFetchResult() -> PHFetchResult<PHAsset>?
    func setPhotos(photos: [UIImage?], fetchResult: PHFetchResult<PHAsset>?)
    func changeObserverRegisterClass() -> PhotoKitAdapter?
}

protocol SelectedPhotosViewPresenterOutputProtocol: AnyObject {
    func updateCollection()
}

class SelectedPhotosPresenter: SelectedPhotosPresenterInputProtocol {
    weak var view: SelectedPhotosViewPresenterOutputProtocol?
    var adapter: PhotoKitAdapter? // FIXME: - add weak
    var router: RouterProtocol?
    var model: SelectedPhotosModel
    
    required init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol, model: SelectedPhotosModel, adapter: PhotoKitAdapter) {
        self.view = view
        self.router = router
        self.model = model
        self.adapter = adapter
    }
    
    func tapOnCloseButton(for view: UICollectionViewController) {
        router?.closeSelectedPhotos(for: view)
    }
    
    func changeObserverRegisterClass() -> PhotoKitAdapter? {
        return adapter
    }
    
//    func startFetching() {
//        self.adapter?.startFetching()
//        view?.updateCollection()
//    }
    
    func getPhotos() -> [UIImage?] {
        return model.photos
    }
    
    func getFetchResult() -> PHFetchResult<PHAsset>? {
        return model.fetchResult
    }
    
    func setPhotos(photos: [UIImage?], fetchResult: PHFetchResult<PHAsset>?) {
        model.photos = photos
        model.fetchResult = fetchResult
        view?.updateCollection()
    }

}
