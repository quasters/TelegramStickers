//
//  PHPickerViewControllerDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 19.05.2022.
//

import Foundation
import PhotosUI

// MARK: - Create Alerts
extension MainViewController {
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
}

// MARK: - Working with Photo LIbrary
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
    
    func openGallery() {
        presenter?.getPhotoLibraryAccessPermission(complition: { status in
            if #available(iOS 14, *) {
                
                switch status {
                case .notDetermined, .denied:
                    self.showWarningAlertToApplicationSettings(message: "Please allow access to your Photo Gallery")
                case .restricted:
                    self.showWarningAlert(message: "The application can't help you create stickers without access to your Photo Gallery :(")
                case .authorized:
                    var config = PHPickerConfiguration()
                    config.selectionLimit = 1
                    config.filter = .images
                    
                    let vc = PHPickerViewController(configuration: config)
                    vc.delegate = self
                    self.present(vc, animated: true)
                case .limited:
                    self.presenter?.showSelectedPhotos()
                default:
                    fatalError("Unknown PHAuthorizationStatus")
                }
                
            } else {
                //FIXME: - Add realization for iOS earlier than 14
                fatalError("iOS version lower than 14.0")
            }
        })
    }
}

// MARK: - Working with camera
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        presenter?.setImage(image: image)
        self.dismiss(animated: true)
    }
    
    func openCamera() {
        presenter?.getCameraAccessPermission(complition: { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true)
                } else {
                    self.showWarningAlert(message: "Your camera doesn't work")
                }
            } else {
                self.showWarningAlertToApplicationSettings(message: "Please allow access to your camera")
            }
        })
    }
}
