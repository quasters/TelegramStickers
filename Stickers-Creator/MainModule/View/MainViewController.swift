//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit
import Foundation
import PhotosUI

class MainViewController: UIViewController {

    var presenter: MainPresenterInputProtocol?
    
    fileprivate let bottomButtonsImages = [ "pencil.circle", "pencil.tip.crop.circle.badge.minus", "eye.circle", "folder.circle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
    }


}

//extension MainViewController {
//
//
//    func setUpBottomButtons() {
//        let stackView = UIStackView()
//    }
//
//    func setUpButtons() -> [UIButton] {
//        for buttonImage in bottomButtonsImages {
//
//        }
//    }
//
//    func configurateButtons(image: String) -> UIButton {
//        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//    }
//}




// MARK: - Configure NavigationView
extension MainViewController {
    
    func configureNavigationView() {
        createInfoButton()
        createRightButtons()
    }
    
    func createInfoButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(pushInfoView(sender:)), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.leftBarButtonItem = infoBarButtonItem
    }
    
    @objc func pushInfoView(sender: UIBarButtonItem) {
        presenter?.tapOnInfoButton()
    }
    
    func createRightButtons() {
        var buttons = [UIBarButtonItem]()
        buttons.append(createButton(image: "camera", isEnabled: true, action: #selector(requestActionSheet)))
        buttons.append(createButton(image: "arrow.uturn.right.circle", isEnabled: false, action: nil))
        buttons.append(createButton(image: "arrow.uturn.backward.circle", isEnabled: false, action: nil))
        buttons.append(createButton(image: "xmark.circle", isEnabled: false, action: nil))
        
        self.navigationItem.rightBarButtonItems = buttons
    }
    
    func createButton(image: String, isEnabled: Bool, action: Selector?) -> UIBarButtonItem {
        let image = UIImage(systemName: image)
        let ButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        ButtonItem.isEnabled = isEnabled
        return ButtonItem
    }
    
    @objc func requestActionSheet() {
        self.presenter?.tapOnCameraButton()
    }
    
    func showCameraActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (UIAlertAction) in
            self.presenter?.checkCameraAccessPermission()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (UIAlertAction) in
            self.presenter?.checkLibraryAccessPermission()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

// MARK: - Photo LIbrary
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
                    fatalError("Unknown PHAuthorizationStatus")
                }
            } else {
                //FIXME: - Add realization for iOS 13 and earlier
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
