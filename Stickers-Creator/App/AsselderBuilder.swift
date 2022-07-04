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
    func createSelectedPhotosModule(router: RouterProtocol) -> UINavigationController?
    func createResultOfChangesModule(router: RouterProtocol, model: MainModel) -> UIViewController?
}

class AsselderBuilder: AsselderBuilderProtocol {
    var mainPresenter: MainPresenter? // SelectedPhotosPresenterDelegate
    
    func createMainModule(router: RouterProtocol) -> UIViewController? {
        let view = MainViewController()
        let accessManager = AccessManager()
        let model = MainModel()
        let presenter = MainPresenter(view: view, router: router, accessManager: accessManager, mainModel: model)
        view.presenter = presenter
        self.mainPresenter = presenter
        return view
    }
    
    func createInfoModule(router: RouterProtocol) -> UIViewController? {
        let view = InfoViewController()
        let infoModel = InfoModel()
        let presenter = InfoPresenter(view: view, router: router, infoModel: infoModel)
        view.presenter = presenter
        return view
    }
    
    func createSelectedPhotosModule(router: RouterProtocol) -> UINavigationController? {
        let navigation = UINavigationController(nibName: "SelectedPhotosNavigationController", bundle: nil)
        let layout = UICollectionViewFlowLayout()
        let view = SelectedPhotosCollectionViewController(collectionViewLayout: layout)
        
        navigation.viewControllers = [view]
        let presenter = SelectedPhotosPresenter(view: view, router: router)
        
        view.presenter = presenter
        presenter.receiverOfImageViaMainView = mainPresenter
        
        return navigation
    }
    
    func createResultOfChangesModule(router: RouterProtocol, model: MainModel) -> UIViewController? {
        let view = ResultOfChangesViewController()
        let presenter = ResultOfChangesPresenter(view: view, model: model, router: router)
        
        view.presenter = presenter
        return view
    }
}
