//
//  MaskImage.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 12.06.2022.
//

import Foundation
import UIKit

class MaskImageBinder: UIView {
    private var maskImage = DrawView()
    private var workspaceImageView = UIImageView()
    private var path: CGPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        workspaceImageView.image = image
        maskImage = getMaskImage(image: image)
        
        //maskImage.delegate = self
        LinesManager.shared.delegate = self
        LinesManager.shared.setImageView(imageView: maskImage)
        
        maskImage.isUserInteractionEnabled = true
        
        workspaceImageView.clipsToBounds = false
        workspaceImageView.contentMode = .scaleAspectFit

        self.addSubview(workspaceImageView)
        self.addSubview(maskImage)
        addConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstrains() {
        
        workspaceImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workspaceImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            workspaceImageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        maskImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maskImage.widthAnchor.constraint(equalTo: workspaceImageView.widthAnchor),
            maskImage.heightAnchor.constraint(equalTo: workspaceImageView.heightAnchor)
        ])
        
    }
    
    private func getMaskImage(image: UIImage) -> DrawView {
        let height = image.size.height * workspaceImageView.image!.scale
        let width = image.size.width * workspaceImageView.image!.scale
        let imageFrame = CGRect(x: 0, y: 0, width: width, height: height)
        
        return DrawView(frame: imageFrame)
    }
}

extension MaskImageBinder: DrawViewDelegate {
    func setMask(_ mask: UIImage?) {
        self.cropImage(mask)
    }
}

extension MaskImageBinder {
    func cropImage(_ mask: UIImage?) {
        guard let mask = mask else { return }

        let maskLayer = CALayer()
        maskLayer.contents = mask.cgImage
        maskLayer.frame.origin = CGPoint(x: 0, y: 0)
        maskLayer.frame = self.bounds

        workspaceImageView.layer.mask = maskLayer
    }
}
