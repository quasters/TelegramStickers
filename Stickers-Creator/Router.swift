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
    func showErrorController(code: Int, message: String)
    func showInfo()
    
    func showSelectedPhotos()
    func closeSelectedPhotos(for view: UICollectionViewController)
    //func closeSelectedPhotos(for view: UICollectionViewController, with image: UIImage)
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
    
    func showErrorController(code: Int, message: String) {
        if let navigationController = navigationController {
            guard let errorVC = assemblyBuilder?.createErrorController(router: self, code: code, message: message) else { return }
            navigationController.pushViewController(errorVC, animated: false)
        }
    }
    
    func showSelectedPhotos() {
        if let navigationController = navigationController {
            guard let selectedPhotosVC = assemblyBuilder?.createSelectedPhotosModule(router: self) else { return }
            selectedPhotosVC.modalPresentationStyle = .fullScreen
            let last = navigationController.viewControllers.first
            last?.present(selectedPhotosVC, animated: true)
        }
    }
    
    func closeSelectedPhotos(for view: UICollectionViewController) {
        view.dismiss(animated: true)
        popToRoot()
    }
    
//    func closeSelectedPhotos(for view: UICollectionViewController, with image: UIImage) {
//        view.dismiss(animated: true)
//    }
    
    func showInfo() {
        if let navigationController = navigationController {
            guard let infoVC = assemblyBuilder?.createInfoModule(router: self) else { return }
            navigationController.pushViewController(infoVC, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }

}
