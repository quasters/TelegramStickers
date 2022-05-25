//
//  MainPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 25.05.2022.
//

import Foundation
import UIKit
import Photos

class MainPresenter: MainPresenterInputProtocol {
    weak var view: MainViewPresenterOutputProtocol?
    var router: RouterProtocol?
    var model: MainModel
    var accessManager: AccessManagerProtocol?
    var photoLibraryObserverViewController: PHPhotoLibraryChangeObserver?
    
    required init(view: MainViewPresenterOutputProtocol, router: RouterProtocol, accessManager: AccessManager, mainModel: MainModel) {
        self.view = view
        self.router = router
        self.accessManager = accessManager
        self.model = mainModel
    }
    
    func tapOnInfoButton() {
        router?.showInfo()
    }
    
    func tapOnCameraButton() {
        view?.showActionSheet()
    }
    
    func getCameraAccessPermission(complition: @escaping (Bool) -> Void) {
        accessManager?.readCameraAccessPermission(complition: { response in
            DispatchQueue.main.async {
                complition(response)
            }
        })
    }
    
    func getPhotoLibraryAccessPermission(complition: @escaping (PHAuthorizationStatus) -> Void) {
        accessManager?.readPhotoLibraryAccessPemission(complition: { status in
            DispatchQueue.main.async {
                complition(status)
            }
        })
    }
    
    func showSelectedPhotos() {
        router?.showSelectedPhotos()
    }
    
    func setImage(image: UIImage?) {
        model.photo = image
    }
}

extension MainPresenter: SelectedPhotosPresenterDelegate {
    func setImage(image: UIImage) {
        self.model.photo = image
        view?.setImageView(image: model.photo!)
    }
}
