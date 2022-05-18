//
//  NavigationModule.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit
    
protocol NavigationModuleBuilderProtocol {
    func buildNavigation()
}

class NavigationModuleBuilder: NavigationModuleBuilderProtocol {
    var navigationController = UINavigationController()
    
    init() {
        buildNavigation()
    }
    
    func buildNavigation() {
        //navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: <#T##Selector?#>)
    }
    
    private func PhotoRequestToPhone() {
        
    }
    
    
}
