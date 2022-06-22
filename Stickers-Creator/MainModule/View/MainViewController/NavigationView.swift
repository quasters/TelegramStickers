//
//  NavigationView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.06.2022.
//

import Foundation
import UIKit

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
    
    private func createInfoButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(pushInfoView(sender:)), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.leftBarButtonItem = infoBarButtonItem
    }
    
    @objc private func pushInfoView(sender: UIBarButtonItem) {
        presenter?.tapOnInfoButton()
    }
    
    private func createRightButtons(clearStatus: Bool, backStatus: Bool, forwardStatus: Bool) {
        var buttons = [UIBarButtonItem]()
        buttons.append(createButton(image: "camera", isEnabled: true, action: #selector(requestActionSheet)))
        buttons.append(createButton(image: "arrow.uturn.right.circle", isEnabled: forwardStatus, action: #selector(nextLine)))
        buttons.append(createButton(image: "arrow.uturn.backward.circle", isEnabled: backStatus, action: #selector(previousLine)))
        buttons.append(createButton(image: "xmark.circle", isEnabled: clearStatus, action: #selector(deleteLines)))
        
        self.navigationItem.rightBarButtonItems = buttons
    }
    
    private func createButton(image: String, isEnabled: Bool, action: Selector?) -> UIBarButtonItem {
        let image = UIImage(systemName: image)
        let ButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        ButtonItem.isEnabled = isEnabled
        return ButtonItem
    }
    
    @objc private func requestActionSheet() {
        self.presenter?.tapOnCameraButton()
    }
    
    @objc private func previousLine() {
        self.presenter?.showPreviusLine()
    }
    
    @objc private func nextLine() {
        self.presenter?.showNextLine()
    }
    
    @objc private func deleteLines() {
        self.presenter?.clearCanvas()
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
