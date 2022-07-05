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
        workspaceScrollView.bounces = true
        workspaceScrollView.delegate = self
        
        presenter?.setStickerSenderDelegate(LinesManager.shared)
              
// MARK: - Сonstraints
        let imageSize = getDisplayedSize(imageSize: image.size, imageViewBoundsSize: self.view.bounds.size)
        workspaceScrollView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        print(workspaceScrollView.frame)
        self.view.addSubview(workspaceScrollView)

        workspaceScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workspaceScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            workspaceScrollView.bottomAnchor.constraint(equalTo: brushSizeSlider.topAnchor, constant: -10),
            workspaceScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            workspaceScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        
        // MARK: - Adds CanvasLayer
        var drawToolsSettingsDelegate: DrawToolsSettingsDelegate? {
            didSet  {
                guard let drawToolsSettingsDelegate = drawToolsSettingsDelegate else { return }
                presenter?.setDrawToolsSettingsDelegate(drawToolsSettingsDelegate)
            }
        }
        workspaceImageView = MaskImageBinder(frame: self.workspaceScrollView.frame, image: image, setterSettingsReceiverDelegate: &drawToolsSettingsDelegate)
        
        
        guard let workspaceImageView = workspaceImageView else { return }
        workspaceImageView.frame = CGRect(x: 0, y: 0, width: workspaceScrollView.frame.width, height: workspaceImageView.frame.height)
        workspaceImageView.center=workspaceScrollView.center
        workspaceScrollView.addSubview(workspaceImageView)
        
        workspaceImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workspaceImageView.widthAnchor.constraint(equalTo: workspaceScrollView.widthAnchor),
            workspaceImageView.heightAnchor.constraint(equalTo: workspaceScrollView.heightAnchor)
        ])
        
        // MARK: - Configure canvas DrawView
        presenter?.setLineWidth(CGFloat(brushSizeSlider.value))
        
        // MARK: - Change buttons to default value
        BottomButtonImageNames.disabledValues = BottomButtonImageNames.disabledValues.map { _ -> Bool in
            let mutableButton = false
            return mutableButton
        }
        BottomButtonImageNames.disabledValues[0] = true
        setUpBottomTools()
    }
    
    private func getDisplayedSize(imageSize: CGSize, imageViewBoundsSize: CGSize) -> CGSize {
        var imageDisplayedSize = CGSize(width: imageViewBoundsSize.width, height: imageViewBoundsSize.height)
        let mW = imageViewBoundsSize.width / imageSize.width
        let mH = imageViewBoundsSize.height / imageSize.height
        if (mH < mW) {
            imageDisplayedSize.width = mH * imageSize.width
        } else if (mW < mH) {
            imageDisplayedSize.height = mW * imageSize.height
        }
        return imageDisplayedSize
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
    
    private func setEmptyScrollViewMessage(_ message: String, size: CGFloat, offset: CGFloat) -> UILabel {
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
