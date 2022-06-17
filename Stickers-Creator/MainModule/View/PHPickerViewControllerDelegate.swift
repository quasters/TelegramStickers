//
//  PHPickerViewControllerDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 15.06.2022.
//

import Foundation
import PhotosUI

// MARK: - PhotoLibrary
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.presenter?.setImage(image: image)
                    }
                }
            }
        }
    }
    
    func requestLibraryPermission() {
        presenter?.getPhotoLibraryAccessPermission(complition: { status in
            if #available(iOS 14, *) {
                switch status {
                case .notDetermined, .denied:
                    self.presenter?.callWarningAlert(message: "Please allow access to your Photo Gallery", goTo: true)
                case .restricted:
                    self.presenter?.callWarningAlert(message: "The application can't help you create stickers without access to your Photo Gallery :(", goTo: false)
                case .authorized:
                    self.presenter?.callGallery()
                case .limited:
                    self.presenter?.showSelectedPhotos()
                default:
                    return
                }
            } else {
                self.presenter?.callWarningAlert(message: "Please update your phone to iOS 14 or newer", goTo: false)
            }
        })
    }
}

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
