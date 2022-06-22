//
//  UIImagePickerControllerDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 21.06.2022.
//

import Foundation
import PhotosUI

// MARK: - Camera
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        presenter?.setImage(image: image)
        self.dismiss(animated: true)
    }
    
    func requestCameraPermission() {
        presenter?.getCameraAccessPermission(complition: { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.presenter?.callCamera()
                } else {
                    self.presenter?.callWarningAlert(message: "Your camera doesn't work", goTo: false)
                }
            } else {
                self.presenter?.callWarningAlert(message: "Please allow access to your camera", goTo: true)
            }
        })
    }
}

