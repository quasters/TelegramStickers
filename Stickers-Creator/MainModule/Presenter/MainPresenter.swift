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
}

protocol MainPresenterOutputProtocol {
    
}

class MainPresenter: MainPresenterInputProtocol {
    func tapOnInfoButton() {
        router?.showInfo()
    }
    
    weak var view: MainViewController?
    var router: RouterProtocol?
    
    required init(view: MainViewController, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
