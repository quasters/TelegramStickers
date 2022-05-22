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
//    func createSelectedPhotosModule(router: RouterProtocol) -> UIViewController?
    func createSelectedPhotosModule(router: RouterProtocol) -> UINavigationController?
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
//        let view = SelectedPhotosViewController(nibName: "SelectedPhotosViewController", bundle: nil)
//        let presenter = SelectedPhotosPresenter(view: view, router: router)
//        view.presenter = presenter
//        return view
//    }
    
    func createSelectedPhotosModule(router: RouterProtocol) -> UINavigationController? {
        let navigation = UINavigationController(nibName: "SelectedPhotosNavigationController", bundle: nil)
        let view = SelectedPhotosViewController()
        //let view = SelectedPhotosNavigationController(nibName: "SelectedPhotosNavigationController", bundle: nil)
        navigation.viewControllers = [view]
        let presenter = SelectedPhotosPresenter(view: view, router: router)
        
        view.presenter = presenter
        return navigation
    }
    
    func createErrorController(router: RouterProtocol, code: Int, message: String) -> UIViewController {
        let view = ErrorViewController()
        let presenter = ErrorPresenter(view: view, router: router, errorCode: code, errorMessage: message)
        view.presenter = presenter
        return view
    }
}
