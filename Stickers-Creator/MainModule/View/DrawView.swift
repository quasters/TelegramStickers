//
//  DrawView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit


protocol DrawViewDelegate: AnyObject {
    func setMask(_ mask: UIImage?)
}

class DrawView: UIImageView {
    public var delegate: DrawViewDelegate?

    private let linesManager = LinesManager()
    private var lineWidth = CGFloat(30)
    private var lineColor = UIColor.white.cgColor
    private var lastPoint: CGPoint!
    private var endPoint: CGPoint!

    private var currentLayer: CAShapeLayer!
    private var maskLayer = CAShapeLayer()
    private var currentPath: UIBezierPath!
    
    private var paths = CGMutablePath()

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)

        currentLayer = CAShapeLayer()
        currentPath = UIBezierPath()
        self.layer.addSublayer(currentLayer)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let currentPoint = touch.location(in: self)
        
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let imageMask = makeMask()
        delegate?.setMask(imageMask)
    }

    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        currentPath.move(to: fromPoint)
        currentPath.addLine(to: toPoint)
        
        currentLayer.path = currentPath.cgPath
        currentLayer.strokeColor = lineColor
        currentLayer.lineWidth = lineWidth
        currentLayer.lineCap = .round
        currentLayer.lineJoin = .round
    }
    
    private func makeMask() -> UIImage? {
        let size = CGSize(width: self.bounds.width, height: self.bounds.height)
                
        UIGraphicsBeginImageContext(size)
        paths.addPath(currentPath.cgPath)
        
        maskLayer.path = paths
        maskLayer.fillRule = .evenOdd
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.lineWidth = lineWidth
        maskLayer.lineCap = .round
        maskLayer.lineJoin = .round

        let renderer = UIGraphicsImageRenderer(size: size)
        let maskImage = renderer.image { context in
            return maskLayer.render(in: context.cgContext)
        }
        UIGraphicsEndImageContext()
        
        let reversedImage = invertMask(maskImage)
        
        return reversedImage
    }
    
    private func invertMask(_ image: UIImage) -> UIImage?
    {
        guard let inputMaskImage = CIImage(image: image),
            let backgroundImageFilter = CIFilter(name: "CIConstantColorGenerator", parameters: [kCIInputColorKey: CIColor.black]),
            let inputColorFilter = CIFilter(name: "CIConstantColorGenerator", parameters: [kCIInputColorKey: CIColor.clear]),
            let inputImage = inputColorFilter.outputImage,
            let backgroundImage = backgroundImageFilter.outputImage,
            let filter = CIFilter(name: "CIBlendWithAlphaMask", parameters: [kCIInputImageKey: inputImage, kCIInputBackgroundImageKey: backgroundImage, kCIInputMaskImageKey: inputMaskImage]),
            let filterOutput = filter.outputImage,
            let outputImage = CIContext().createCGImage(filterOutput, from: inputMaskImage.extent) else { return nil }
        let finalOutputImage = UIImage(cgImage: outputImage)
        return finalOutputImage
    }
}


