//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import Photos
import UIKit

protocol MainPresenterInputProtocol: AnyObject {
    init(view: MainViewPresenterOutputProtocol, router: RouterProtocol, accessManager: AccessManager, mainModel: MainModel)
    
    func tapOnInfoButton()
    func tapOnCameraButton()
    
    func getCameraAccessPermission(complition: @escaping (Bool) -> Void)
    func getPhotoLibraryAccessPermission(complition: @escaping (PHAuthorizationStatus) -> Void)
    
    func checkLibraryAccessPermission()
    func checkCameraAccessPermission()
    
    func callWarningAlert(message: String, goTo applicationSettings: Bool)
    func callGallery()
    func callCamera()
    
    func showSelectedPhotos()
    func setImage(image: UIImage?)
}

protocol MainViewPresenterOutputProtocol: AnyObject {
    func setImageView(image: UIImage)
    
    func showActionSheet()
    
    func checkAccessToCamera()
    func checkAccessToLibrary()
    
    func showWarningAlert(message: String)
    func showWarningAlertToApplicationSettings(message: String)
    
    func openGallery()
    func openCamera()
}
