//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    var presenter: MainPresenterInputProtocol?
    
    let bottomButtonsImages = [ "pencil.circle", "pencil.tip.crop.circle.badge.minus", "eye.circle", "folder.circle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
    }


}

extension MainViewController: MainViewPresenterOutputProtocol {
    func setImageView(image: UIImage) {
//        let y = Float((self.view.window?.windowScene?.statusBarManager?.statusBarFrame.minY) ?? 0) + Float(self.navigationController?.navigationBar.frame.minY ?? 0)
//        let newImage = UIImageView(frame: CGRect(x: 0, y: CGFloat(y), width: image.size.width, height: image.size.height))
    }
    
    func showActionSheet() {
        self.showCameraActionSheet()
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
        buttons.append(createButton(image: "camera", isEnabled: true, action: #selector(showCameraActionSheet)))
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
    
    @objc func showCameraActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (UIAlertAction) in
            self.openCamera() // PickerExtensions
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (UIAlertAction) in
            self.openGallery() // PickerExtensions
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
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
