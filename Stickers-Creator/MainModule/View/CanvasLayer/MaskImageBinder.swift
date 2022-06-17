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
    private var path: CGPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image: UIImage, setterSettingsReceiverDelegate: inout DrawToolsSettingsDelegate?) {
        self.init(frame: frame)
        imageView.image = image
        
        drawView = getMaskImage(image: image)
        setterSettingsReceiverDelegate = drawView
        
        //LinesManager.shared.delegate = self
        LinesManager.shared.setImageView(imageView: drawView)
        
        drawView.isUserInteractionEnabled = true
        
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
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        drawView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            drawView.heightAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
    }
    
    private func getMaskImage(image: UIImage) -> DrawView {
        let height = image.size.height * imageView.image!.scale
        let width = image.size.width * imageView.image!.scale
        let imageFrame = CGRect(x: 0, y: 0, width: width, height: height)
        
        return DrawView(frame: imageFrame)
    }
}

//extension MaskImageBinder: DrawViewDelegate {
//    func setMask(_ mask: UIImage?) {
//        self.cropImage(mask)
//    }
//}

extension MaskImageBinder {
    private func cropImage(_ mask: UIImage?) {
        guard let mask = mask else { return }

        let maskLayer = CALayer()
        maskLayer.contents = mask.cgImage
        maskLayer.frame.origin = CGPoint(x: 0, y: 0)
        maskLayer.frame = self.bounds

        imageView.layer.mask = maskLayer
    }
}
