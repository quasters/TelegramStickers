//
//  AsselderBuilder.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

protocol AsselderBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createInfoModule(router: RouterProtocol) -> UIViewController
    func createSelectedPhotosModule(router: RouterProtocol) -> UIViewController
}

class AsselderBuilder: AsselderBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let accessManager = AccessManager()
        let presenter = MainPresenter(view: view, router: router, accessManager: accessManager)
        view.presenter = presenter
        return view
    }
    
    func createInfoModule(router: RouterProtocol) -> UIViewController {
        let view = InfoViewController()
        let infoModel = InfoModel()
        let presenter = InfoPresenter(router: router, infoModel: infoModel)
        view.presenter = presenter
        return view
    }

    func createSelectedPhotosModule(router: RouterProtocol) -> UIViewController {
        let view = SelectedPhotosViewController()
        let presenter = SelectedPhotosPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
