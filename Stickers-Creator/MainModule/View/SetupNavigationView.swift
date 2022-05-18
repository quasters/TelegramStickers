//
//  setupNavigationView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 19.05.2022.
//

import Foundation
import UIKit

extension MainViewController {
    
// MARK: - infoButton
    func configureTabView() {
        //self.title = "Stickers"
        createInfoTabButton()
        createRightButtons()
    }
    
    func createInfoTabButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(pushInfoView(sender:)), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.leftBarButtonItem = infoBarButtonItem
    }
    
    @objc func pushInfoView(sender: UIBarButtonItem) {
        presenter?.tapOnInfoButton()
    }
    
// MARK: - rightButtons
    func createRightButtons() {
        var buttons = [UIBarButtonItem]()
        buttons.append(createButton(image: "camera", isEnabled: true, action: #selector(showActionSheet)))
        buttons.append(createButton(image: "arrow.uturn.right.circle", isEnabled: false, action: nil))
        buttons.append(createButton(image: "arrow.uturn.backward.circle", isEnabled: false, action: nil))
        
        self.navigationItem.rightBarButtonItems = buttons
    }
    
    func createButton(image: String, isEnabled: Bool, action: Selector?) -> UIBarButtonItem {
        let image = UIImage(systemName: image)
        let rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        rightButtonItem.isEnabled = isEnabled
        return rightButtonItem
    }
    
// MARK: - photoActionSheet
    @objc func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (UIAlertAction) in
            self.openCamera() // PickerExtensions
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (UIAlertAction) in
            self.openGallery() // PickerExtensions
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("Cancel")
        }))
        
        self.present(alert, animated: true)
    }
}
