//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

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
    func getImage() -> UIImage?
    
    func showNextLine()
    func showPreviusLine()
    func clearCanvas()
    
    func setStickerSenderDelegate(_ delegate: MainPresenterStickerSenderDelegate)
    
    func tapOnToolButton(tool: BottomButtonImageNames)
    func setDrawToolsSettingsDelegate(_ delegate: DrawToolsSettingsDelegate)
    func setLineWidth(_ width: CGFloat)
}

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
