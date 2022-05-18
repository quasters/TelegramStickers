//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation

protocol MainPresenterInputProtocol {
    init(view: MainViewController, router: RouterProtocol)
    func tapOnInfoButton()
    func selectPhoto()
}

protocol MainPresenterOutputProtocol {
    
}

class MainPresenter: MainPresenterInputProtocol {
    weak var view: MainViewController?
    var router: RouterProtocol?
    
    required init(view: MainViewController, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func tapOnInfoButton() {
        router?.showInfo()
    }
    
    func selectPhoto() {
        
    }
}
