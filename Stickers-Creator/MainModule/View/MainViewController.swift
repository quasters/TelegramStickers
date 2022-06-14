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
    var bottomButtonsStackView = UIStackView()
    var brushSizeSlider = UISlider()
    var workspaceImageView: MaskImageBinder?//UIImageView()
    
    var linesCount: UInt = 0 {
        didSet {
            self.currentLine = linesCount
        }
    }
    var currentLine: UInt = 0
    
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
        bottomButtonsStackView = UIStackView(arrangedSubviews: buttons)

        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .equalSpacing
        view.addSubview(bottomButtonsStackView)
        
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomButtonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            bottomButtonsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonsStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        setupSlider()
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
    
    func setupSlider() {
        brushSizeSlider.minimumValue = 1.0
        brushSizeSlider.maximumValue = 30.0
        brushSizeSlider.value = 15.5
        //brushSizeSlider.backgroundColor = .red
        brushSizeSlider.addTarget(self, action: #selector(changeBrushSize), for: .valueChanged)
        
        self.view.addSubview(brushSizeSlider)
        brushSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brushSizeSlider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            brushSizeSlider.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            brushSizeSlider.heightAnchor.constraint(equalToConstant: 30),
            brushSizeSlider.bottomAnchor.constraint(equalTo: bottomButtonsStackView.topAnchor, constant: -15)
        ])
    }
    
    @objc func changeBrushSize() {
        
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
        buttons.append(createButton(image: "arrow.uturn.right.circle", isEnabled: (currentLine < linesCount), action: #selector(nextLine)))
        buttons.append(createButton(image: "arrow.uturn.backward.circle", isEnabled: (currentLine != 0), action: #selector(previousLine)))
        buttons.append(createButton(image: "xmark.circle", isEnabled: (currentLine != 0), action: #selector(deleteLines)))
        
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
    
    @objc func previousLine() {
        currentLine -= 1
        createRightButtons()
    }
    
    @objc func nextLine() {
        currentLine += 1
        createRightButtons()
    }
    
    @objc func deleteLines() {
        currentLine = 0
        createRightButtons()
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
