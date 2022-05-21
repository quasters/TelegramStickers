//
//  AsselderBuilder.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

protocol AsselderBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController?
    func createInfoModule(router: RouterProtocol) -> UIViewController?
    func createSelectedPhotosModule(router: RouterProtocol) -> UIViewController?
    func createErrorController(router: RouterProtocol, code: Int, message: String) -> UIViewController
}

class AsselderBuilder: AsselderBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController? {
        let view = MainViewController()
        let accessManager = AccessManager()
        let presenter = MainPresenter(view: view, router: router, accessManager: accessManager)
        view.presenter = presenter
        return view
    }
    
    func createInfoModule(router: RouterProtocol) -> UIViewController? {
        let view = InfoViewController()
        let infoModel = InfoModel()
        let presenter = InfoPresenter(view: view, router: router, infoModel: infoModel)
        view.presenter = presenter
        return view
    }

//    func createSelectedPhotosModule(router: RouterProtocol) -> UIViewController? {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let view = storyboard.instantiateViewController(withIdentifier: "SelectedPhotosVC") as? SelectedPhotosViewController
//        else { return nil }
//        let presenter = SelectedPhotosPresenter(view: view, router: router)
//        view.presenter = presenter
//        return view
//    }
    
    func createSelectedPhotosModule(router: RouterProtocol) -> UIViewController? {
        let view = SelectedPhotosViewController(nibName: "SelectedPhotosViewController", bundle: nil)
        let presenter = SelectedPhotosPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createErrorController(router: RouterProtocol, code: Int, message: String) -> UIViewController {
        let view = ErrorViewController()
        let presenter = ErrorPresenter(view: view, router: router, errorCode: code, errorMessage: message)
        view.presenter = presenter
        return view
    }
}
