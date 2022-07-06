//
//  MaskImage.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 12.06.2022.
//

import Foundation
import UIKit

class MaskImageBinder: UIView {
    private var drawView = DrawView() // The canvas
    private var imageView = UIImageView() // UIImageView with selected image
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image: UIImage, setterSettingsReceiverDelegate: inout DrawToolsSettingsDelegate?) {
        self.init(frame: frame)
        imageView.frame = frame
        drawView.frame = frame

        imageView.image = image

        setterSettingsReceiverDelegate = drawView
        
        LinesManager.shared.setImageView(imageView: drawView)
        
        drawView.isUserInteractionEnabled = true
        drawView.isMultipleTouchEnabled = false
        
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit

        self.addSubview(imageView)
        self.addSubview(drawView)
        addConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSettingsReceiver() -> DrawToolsSettingsDelegate {
        return drawView
    }
    
    private func addConstrains() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.bounds.width),
            imageView.heightAnchor.constraint(equalToConstant: self.bounds.height)

        ])
    }
}

extension MaskImageBinder {
    func cropImage(_ mask: UIImage?) -> MainModel {
        return MainModel(photo: imageView.image, mask: mask)

    }
}
