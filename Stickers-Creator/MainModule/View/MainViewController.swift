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
    
    var workspaceScrollView = UIScrollView()
    var textVC = UIView()
    var stackView = UIStackView()
    var workspaceImageView = UIImageView()
    
    fileprivate let bottomButtonsImages = [ "pencil.circle", "scissors.circle", "circle.bottomhalf.filled",  "eye.circle", "folder.circle"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
        setUpBottomButtons()
        showEmptyScrollViewNotice()
        //configurateWorkspace()
    }


}

// MARK: - Bottom buttons
extension MainViewController {

    func setUpBottomButtons() {
        let buttons = setUpButtons()
        stackView = UIStackView(arrangedSubviews: buttons)

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    func setUpButtons() -> [UIButton] {
        var buttons = [UIButton]()
        for buttonImage in bottomButtonsImages {
            let button = configurateButton(imageName: buttonImage)
            buttons.append(button)
        }
        
        return buttons
    }

    func configurateButton(imageName: String) -> UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        return button
    }
}

// MARK: - UIScrollView
extension MainViewController: UIScrollViewDelegate {
    func configurateWorkspace(image: UIImage) {
        workspaceScrollView.minimumZoomScale = 1
        workspaceScrollView.maximumZoomScale = 5
        workspaceScrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        workspaceScrollView.panGestureRecognizer.maximumNumberOfTouches = 2
        workspaceScrollView.zoomScale = 1
        workspaceScrollView.flashScrollIndicators()
        workspaceScrollView.bounces = true
        workspaceScrollView.delegate = self


        self.view.addSubview(workspaceScrollView)
        workspaceScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workspaceScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            workspaceScrollView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            workspaceScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            workspaceScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        configurateWorkspaceImage(image: image)
    }
    
    func configurateWorkspaceImage(image: UIImage) {
        workspaceImageView = UIImageView()
        workspaceImageView.image = image
        workspaceImageView.backgroundColor = .blue
        workspaceImageView.clipsToBounds = false
        workspaceImageView.contentMode = .scaleAspectFit
        
        workspaceScrollView.addSubview(workspaceImageView)
        
        workspaceImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workspaceImageView.widthAnchor.constraint(equalTo: workspaceScrollView.widthAnchor),
            workspaceImageView.heightAnchor.constraint(equalTo: workspaceScrollView.heightAnchor)
        ])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return workspaceImageView
    }
    
    fileprivate func showEmptyScrollViewNotice() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        textVC = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let title = setEmptyScrollViewMessage("Create your new Sticker", size: 30, offset: -37)
        let message = setEmptyScrollViewMessage("By clicking the Camera Button above, you can select an image from the Photo Gallery or Take a Photo", size: 17, offset: +25)
        textVC.addSubview(title)
        textVC.addSubview(message)
        self.view.addSubview(textVC)
    }
    
    fileprivate func setEmptyScrollViewMessage(_ message: String, size: CGFloat, offset: CGFloat) -> UILabel {
        let width = self.view.bounds.width - 40
        let height = self.view.bounds.height
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Arial", size: size)
        messageLabel.sizeToFit()
        messageLabel.center.x = self.view.center.x
        messageLabel.center.y = self.view.center.y + offset
        return messageLabel
    }
}


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
