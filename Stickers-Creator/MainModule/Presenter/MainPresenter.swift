//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import Photos

protocol MainPresenterInputProtocol: AnyObject {
    init(view: MainViewPresenterOutputProtocol, router: RouterProtocol, accessManager: AccessManager)
    func tapOnInfoButton()
    func getCameraAccessPermission(complition: @escaping (Bool) -> Void)
    func getPhotoLibraryAccessPermission(complition: @escaping (PHAuthorizationStatus) -> Void)
    func showSelectedPhotos()
}

protocol MainViewPresenterOutputProtocol: AnyObject {
    
}

class MainPresenter: MainPresenterInputProtocol {
    weak var view: MainViewPresenterOutputProtocol?
    var router: RouterProtocol?
    var accessManager: AccessManagerProtocol?
    var photoLibraryObserverViewController: PHPhotoLibraryChangeObserver?
    
    required init(view: MainViewPresenterOutputProtocol, router: RouterProtocol, accessManager: AccessManager) {
        self.view = view
        self.router = router
        self.accessManager = accessManager
    }
    
    func tapOnInfoButton() {
        router?.showInfo()
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
    
}
