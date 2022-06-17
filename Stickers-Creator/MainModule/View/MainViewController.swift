//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit
import Foundation
import PhotosUI

protocol DrawToolsSettingsDelegate {
    func setLineWidth(_ width: CGFloat)
    func setTool(_ isErase: Bool)
}

class MainViewController: UIViewController {
    var presenter: MainPresenterInputProtocol?
    
    var drawToolsSettingsDelegate: DrawToolsSettingsDelegate?
    
    var workspaceScrollView = UIScrollView()
    var textVC = UIView()
    var bottomButtonsStackView = UIStackView()
    var brushSizeSlider = UISlider()
    var workspaceImageView: MaskImageBinder?//UIImageView()
        
    fileprivate let bottomButtonsImages = [ "scissors.circle", "pencil.circle", "circle.bottomhalf.filled",  "eye.circle", "folder.circle"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        configureNavigationView()
        setUpBottomButtons()
        showEmptyScrollViewNotice()
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

    
    // FIXME: - add targets
    func configurateButton(imageName: String) -> UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        return button
    }
    
    func setupSlider() {
        brushSizeSlider.minimumValue = 5.0
        brushSizeSlider.maximumValue = 75.0
        brushSizeSlider.value = 39.6

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
        drawToolsSettingsDelegate?.setLineWidth(CGFloat(brushSizeSlider.value))
    }
}

// MARK: - Configure NavigationView
extension MainViewController: LinesManagerButtonSettingsDelegate {
    func reloadActivityStatus(clearStatus: Bool, backStatus: Bool, forwardStatus: Bool) {
        createRightButtons(clearStatus: clearStatus, backStatus: backStatus, forwardStatus: forwardStatus)
    }
    
    func configureNavigationView() {
        createInfoButton()
        createRightButtons(clearStatus: false, backStatus: false, forwardStatus: false)
        LinesManager.shared.buttonSettingsDelegate = self
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
    
    func createRightButtons(clearStatus: Bool, backStatus: Bool, forwardStatus: Bool) {
        var buttons = [UIBarButtonItem]()
        buttons.append(createButton(image: "camera", isEnabled: true, action: #selector(requestActionSheet)))
        buttons.append(createButton(image: "arrow.uturn.right.circle", isEnabled: forwardStatus, action: #selector(nextLine)))
        buttons.append(createButton(image: "arrow.uturn.backward.circle", isEnabled: backStatus, action: #selector(previousLine)))
        buttons.append(createButton(image: "xmark.circle", isEnabled: clearStatus, action: #selector(deleteLines)))
        
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
        LinesManager.shared.previusLine()
    }
    
    @objc func nextLine() {
        LinesManager.shared.nextLine()
    }
    
    @objc func deleteLines() {
        LinesManager.shared.clearCanvas()
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
