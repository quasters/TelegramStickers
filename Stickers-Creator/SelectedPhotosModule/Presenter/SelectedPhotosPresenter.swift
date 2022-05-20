//
//  SelectedPhotosPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import Foundation

protocol SelectedPhotosPresenterInputProtocol {
    init(view: SelectedPhotosViewController, router: RouterProtocol)
}

protocol SelectedPhotosPresenterPresenterOutputProtocol {
    
}

class SelectedPhotosPresenter: SelectedPhotosPresenterInputProtocol {
    weak var view: SelectedPhotosViewController?
    var router: RouterProtocol?
    
    required init(view: SelectedPhotosViewController, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
