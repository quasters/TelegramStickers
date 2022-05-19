//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import Photos

protocol MainPresenterInputProtocol {
    init(view: MainViewController, router: RouterProtocol, accessManager: AccessManager)
    func tapOnInfoButton()
    func getCameraAccessPermission(complition: @escaping (Bool) -> Void)
    func getPhotoLibraryAccessPermission(complition: @escaping (PHAuthorizationStatus) -> Void)
}

protocol MainPresenterOutputProtocol {
    
}

class MainPresenter: MainPresenterInputProtocol {
    weak var view: MainViewController?
    var router: RouterProtocol?
    var accessManager: AccessManagerProtocol?
    
    required init(view: MainViewController, router: RouterProtocol, accessManager: AccessManager) {
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
            complition(status)
        })
    }
    

    
}
