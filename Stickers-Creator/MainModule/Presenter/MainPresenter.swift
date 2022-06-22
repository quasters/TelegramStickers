//
//  MainPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 25.05.2022.
//

import Foundation
import UIKit
import Photos

class MainPresenter: MainPresenterInputProtocol {    
    weak var view: MainViewPresenterOutputProtocol?
    fileprivate var router: RouterProtocol?
    fileprivate var model: MainModel
    fileprivate var accessManager: AccessManagerProtocol?
    fileprivate var photoLibraryObserverViewController: PHPhotoLibraryChangeObserver?
    fileprivate var drawToolsSettingsDelegate: DrawToolsSettingsDelegate?
    
    required init(view: MainViewPresenterOutputProtocol, router: RouterProtocol, accessManager: AccessManager, mainModel: MainModel) {
        self.view = view
        self.router = router
        self.accessManager = accessManager
        self.model = mainModel
    }
    
    func tapOnInfoButton() {
        router?.showInfo()
    }
    
    func tapOnCameraButton() {
        view?.showActionSheet()
    }
    
    func getCameraAccessPermission(complition: @escaping (Bool) -> Void) {
        accessManager?.readCameraAccessPermission(complition: { response in
            DispatchQueue.main.async {
                complition(response)
            }
        })
    }
    
    func getPhotoLibraryAccessPermission(complition: @escaping (PHAuthorizationStatus) -> Void) {
        accessManager?.readPhotoLibraryAccessPemission(complition: { status in
            DispatchQueue.main.async {
                complition(status)
            }
        })
    }
    
    func checkCameraAccessPermission() {
        view?.checkAccessToCamera()
    }
    
    func checkLibraryAccessPermission() {
        view?.checkAccessToLibrary()
    }
    
    func callWarningAlert(message: String, goTo applicationSettings: Bool) {
        applicationSettings ? view?.showWarningAlertToApplicationSettings(message: message) : view?.showWarningAlert(message: message)
    }
    
    func callGallery() {
        view?.openGallery()
    }
    
    func callCamera() {
        view?.openCamera()
    }
    
    func showSelectedPhotos() {
        router?.showSelectedPhotos()
    }
    
    func setImage(image: UIImage?) {
        if let image = image {
            self.setImage(image: image)
        }
    }
    
    func getImage() -> UIImage? {
        return model.photo
    }
    
    func showNextLine() {
        LinesManager.shared.nextLine()
    }
    
    func showPreviusLine() {
        LinesManager.shared.previusLine()
    }
    
    func clearCanvas() {
        LinesManager.shared.clearCanvas()
    }
    
    func tapOnToolButton(tool: BottomButtonImageNames) {
        guard let pencilIndex = BottomButtonImageNames.allValues.firstIndex(of: .Pencil) else { return }
        guard let eraserIndex = BottomButtonImageNames.allValues.firstIndex(of: .Eraser) else { return }
        
        switch tool {
        case .Pencil:
            BottomButtonImageNames.disabledValues[pencilIndex] = true
            BottomButtonImageNames.disabledValues[eraserIndex] = false
        case .Eraser:
            BottomButtonImageNames.disabledValues[pencilIndex] = false
            BottomButtonImageNames.disabledValues[eraserIndex] = true
        case .Ruler:
            guard let rulerIndex = BottomButtonImageNames.allValues.firstIndex(of: .Ruler) else { return }
            BottomButtonImageNames.disabledValues[rulerIndex] = !BottomButtonImageNames.disabledValues[rulerIndex]
        case .Eye:
            return
        case .Folder:
            return
        }
        
        drawToolsSettingsDelegate?.setTool(tool)
        view?.reloadToolButtons()
    }
    
    func setDrawToolsSettingsDelegate(_ delegate: DrawToolsSettingsDelegate?) {
        self.drawToolsSettingsDelegate = delegate
    }
    
    func setLineWidth(_ width: CGFloat) {
        drawToolsSettingsDelegate?.setLineWidth(width)
    }
}

extension MainPresenter: SelectedPhotosPresenterDelegate {
    func setImage(image: UIImage) {
        self.model.photo = image
        view?.loadImageToWorkspace(image: image)
    }
}
