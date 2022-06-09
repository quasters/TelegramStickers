//
//  UIScrollView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import UIKit

extension MainViewController: UIScrollViewDelegate {
    func configurateWorkspace(image: UIImage) {
        workspaceScrollView.minimumZoomScale = 1
        workspaceScrollView.maximumZoomScale = 20
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
            workspaceScrollView.bottomAnchor.constraint(equalTo: brushSizeSlider.topAnchor, constant: -10),
            workspaceScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            workspaceScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        configurateWorkspaceImage(image: image)
    }
    
    func configurateWorkspaceImage(image: UIImage) {
        workspaceImageView = DrawView()
        //workspaceImageView.backgroundColor = .red
        workspaceImageView.image = image
        workspaceImageView.clipsToBounds = false
        workspaceImageView.contentMode = .scaleAspectFit
        workspaceImageView.isUserInteractionEnabled = true
        
        
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
    
    func showEmptyScrollViewNotice() {
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
