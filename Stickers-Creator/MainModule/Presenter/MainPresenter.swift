//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import Photos
import UIKit

protocol MainPresenterInputProtocol: AnyObject {
    init(view: MainViewPresenterOutputProtocol, router: RouterProtocol, accessManager: AccessManager, mainModel: MainModel)
    
    func tapOnInfoButton()
    func getCameraAccessPermission(complition: @escaping (Bool) -> Void)
    func getPhotoLibraryAccessPermission(complition: @escaping (PHAuthorizationStatus) -> Void)
    func showSelectedPhotos()
    
    //func setImage(image: UIImage)
}

protocol MainViewPresenterOutputProtocol: AnyObject {
    func setImageView(image: UIImage)
}

extension MainPresenter: SelectedPhotosPresenterDelegate {
    func setImage(image: UIImage) {
        self.model.photo = image
        view?.setImageView(image: model.photo!)
    }
}

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
    
    
    
//    func setImage(image: UIImage) {
//        model.photo = image
//        view?.setImage(image: image)
//    }
    
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
