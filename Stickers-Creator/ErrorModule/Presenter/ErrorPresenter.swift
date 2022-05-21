//
//  ErrorPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 21.05.2022.
//

import Foundation

protocol ErrorPresenterInputProtocol: AnyObject {
    func setErrorCode()
    func tapOnBackButton()
}

protocol ErrorViewPresenterOutputProtocol: AnyObject {
    func showError(code: Int, message: String)
}

//not working now. maybe delete

class ErrorPresenter: ErrorPresenterInputProtocol {
    var view: ErrorViewPresenterOutputProtocol?
    var router: RouterProtocol?
    var errorCode: Int
    var errorMessage: String
    
    init(view: ErrorViewPresenterOutputProtocol, router: RouterProtocol, errorCode: Int, errorMessage: String) {
        self.view = view
        self.router = router
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
    
    func setErrorCode() {
        view?.showError(code: self.errorCode, message: self.errorMessage)
    }
    
    func tapOnBackButton() {
        router?.popToRoot()
    }
}

