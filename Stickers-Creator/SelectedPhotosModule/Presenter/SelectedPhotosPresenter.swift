//
//  SelectedPhotosPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import Foundation
import UIKit

protocol SelectedPhotosPresenterInputProtocol: AnyObject {
    init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol)
}

protocol SelectedPhotosViewPresenterOutputProtocol: AnyObject {
    
}

class SelectedPhotosPresenter: SelectedPhotosPresenterInputProtocol {
    weak var view: SelectedPhotosViewPresenterOutputProtocol?
    var router: RouterProtocol?
    
    required init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func tapOnCloseButton(for view: UICollectionViewController) {
        router?.closeSelectedPhotos(for: view)
    }
}
