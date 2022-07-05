//
//  ChangesResultPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 23.06.2022.
//

import Foundation
import UIKit

class ResultOfChangesPresenter: ResultOfChangesPresenterInputProtocol {    
    weak var view: ResultOfChangesPresenterOutputProtocol?
    private var router: RouterProtocol?
    private var model: MainModel?
    
    required init(view: ResultOfChangesPresenterOutputProtocol, model: MainModel, router: RouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func getImage() -> UIImage? {
        return model?.photo
    }
    
    func getMask() -> UIImage? {
        return model?.mask
    }
    
    func tappedDoneButton() {
        view?.saveImage()
    }
}
