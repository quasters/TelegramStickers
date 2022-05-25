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
    init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol)
    func moveToRoot(for view: UICollectionViewController)
    func moveToRoot(for view: UICollectionViewController, image: UIImage)
}

protocol SelectedPhotosViewPresenterOutputProtocol: AnyObject {
    func tapOnCloseButton()
    func choseImage(image: UIImage)
}

protocol SelectedPhotosPresenterDelegate {
    func setImage(image: UIImage)
}

class SelectedPhotosPresenter: SelectedPhotosPresenterInputProtocol {
    var receiverOfImageViaMainView: SelectedPhotosPresenterDelegate?
    
    weak var view: SelectedPhotosViewPresenterOutputProtocol?
    var router: RouterProtocol?
    
    required init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func moveToRoot(for view: UICollectionViewController) {
        router?.closeSelectedPhotos(for: view)
    }
    
    func moveToRoot(for view: UICollectionViewController, image: UIImage) {
        receiverOfImageViaMainView?.setImage(image: image)
        moveToRoot(for: view)
    }
}

