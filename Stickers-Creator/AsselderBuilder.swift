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

}

class AsselderBuilder: AsselderBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createInfoModule(router: RouterProtocol) -> UIViewController {
        let view = InfoViewController()
        let presenter = InfoPresenter(router: router)
        view.presenter = presenter
        return view
    }

    
}
