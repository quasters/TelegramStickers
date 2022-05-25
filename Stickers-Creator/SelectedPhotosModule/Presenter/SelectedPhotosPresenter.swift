//
//  SelectedPhotosPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import Foundation
import Photos
import UIKit

class SelectedPhotosPresenter: SelectedPhotosPresenterInputProtocol {
    weak var view: SelectedPhotosViewPresenterOutputProtocol?
    var receiverOfImageViaMainView: SelectedPhotosPresenterDelegate?
    fileprivate var router: RouterProtocol?
    
    required init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func tapOnEditButton() {
        view?.showActionSheet()
    }
    
    func selectMorePhotos() {
        view?.pickMorePhotos()
    }
    
    func changedLibrary(currentQuantity: Int) {
        currentQuantity > 0 ? view?.hideNotice() : view?.showNotice()
    }
    
    func moveToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func moveToRoot(for view: UICollectionViewController) {
        router?.closeSelectedPhotos(for: view)
    }
    
    func moveToRoot(for view: UICollectionViewController, image: UIImage) {
        receiverOfImageViaMainView?.setImage(image: image)
        moveToRoot(for: view)
    }

}

