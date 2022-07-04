//
//  Router.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AsselderBuilderProtocol? { get set }
    
    func initialViewController()
    
    func showSelectedPhotos()
    func closeSelectedPhotos(for view: UICollectionViewController)
    
    func showInfo()
    
    func showResultOfChanges(model: MainModel)
    
    func popToRoot()

}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AsselderBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AsselderBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainVC = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [mainVC]
        }
    }
    
    func showSelectedPhotos() {
        if let navigationController = navigationController {
            guard let selectedPhotosVC = assemblyBuilder?.createSelectedPhotosModule(router: self) else { return }
            selectedPhotosVC.modalPresentationStyle = .fullScreen
            let first = navigationController.viewControllers.first
            first?.present(selectedPhotosVC, animated: true)
        }
    }
    
    func closeSelectedPhotos(for view: UICollectionViewController) {
        view.dismiss(animated: true)
        popToRoot()
    }
    
    func showInfo() {
        if let navigationController = navigationController {
            guard let infoVC = assemblyBuilder?.createInfoModule(router: self) else { return }
            navigationController.pushViewController(infoVC, animated: true)
        }
    }
    
    func showResultOfChanges(model: MainModel) {
        if let navigationController = navigationController {
            guard let ResultOfChangesVC = assemblyBuilder?.createResultOfChangesModule(router: self, model: model) else { return }
            navigationController.pushViewController(ResultOfChangesVC, animated: false)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
