//
//  PHPickerViewControllerDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 19.05.2022.
//

import Foundation
import PhotosUI

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Your camera doesn't work", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            self.present(alert, animated: true)
        }
    }
}
