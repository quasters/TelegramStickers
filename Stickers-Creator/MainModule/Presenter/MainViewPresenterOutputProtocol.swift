//
//  MainViewPresenterOutputProtocol.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import UIKit

protocol MainViewPresenterOutputProtocol: AnyObject {
    func showActionSheet()
    
    func checkAccessToCamera()
    func checkAccessToLibrary()
    
    func showWarningAlert(message: String)
    func showWarningAlertToApplicationSettings(message: String)
    
    func openGallery()
    func openCamera()
    
    func loadImageToWorkspace(image: UIImage)
    
    func reloadToolButtons()
}
