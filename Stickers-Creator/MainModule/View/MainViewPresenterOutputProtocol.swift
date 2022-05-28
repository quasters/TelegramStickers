//
//  PHPickerViewControllerDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 19.05.2022.
//

import Foundation
import PhotosUI

// MARK: - MainViewPresenterOutputProtocol
extension MainViewController: MainViewPresenterOutputProtocol {
//    func setImageView(image: UIImage) {
//        let y = Float((self.view.window?.windowScene?.statusBarManager?.statusBarFrame.minY) ?? 0) + Float(self.navigationController?.navigationBar.frame.minY ?? 0)
//        let newImage = UIImageView(frame: CGRect(x: 0, y: CGFloat(y), width: image.size.width, height: image.size.height))
//    }
    
    func showActionSheet() {
        showCameraActionSheet()
    }
    
    func checkAccessToCamera() {
        requestCameraPermission()
    }
    
    func showWarningAlert(message: String) {
        let alert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func showWarningAlertToApplicationSettings(message: String) {
        let alert = UIAlertController(title: "Warning!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true)
    }
    
    func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func checkAccessToLibrary() {
        requestLibraryPermission()
    }
    
    func loadImageToWorkspace(image: UIImage) {
        self.textVC.removeFromSuperview()
        self.workspaceScrollView.removeFromSuperview()
        self.workspaceImageView.removeFromSuperview()
        
        self.configurateWorkspace(image: image)
    }
}
