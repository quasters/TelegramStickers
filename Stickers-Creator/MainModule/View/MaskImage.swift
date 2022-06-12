//
//  MaskImage.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 12.06.2022.
//

import Foundation
import UIKit

class MaskImage: UIView {
    private var maskImage: DrawView?
    private var workspaceImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        workspaceImageView.image = image
        maskImage = getMaskImage(image: image)
        guard let maskImage = maskImage else { return }

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
        
        guard let maskImage = maskImage else { return }
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
