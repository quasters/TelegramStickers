//
//  ImageMask.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 15.06.2022.
//

import Foundation
import UIKit

class ImageMaskCreator {
    static var shared = ImageMaskCreator()
    private init(){}
    
    func create(frame: CGRect, lines: [LineModel], currentLine: Int) -> UIImage? {
        let size = CGSize(width: frame.width, height: frame.height)
        
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.clear(frame)
        
        for (index, line) in lines.enumerated() where index < currentLine {
            context.addPath(line.path)
            context.setBlendMode( !line.isErase ? .color : .clear )
            context.setLineWidth(line.width)
            context.setStrokeColor(UIColor.white.cgColor)
            context.setLineCap(CGLineCap.round)
            context.setLineJoin(CGLineJoin.round)
            context.strokePath()
        }
        
        guard let maskCGImage = context.makeImage() else { return nil }
        let maskImage = UIImage(cgImage: maskCGImage)
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
    
    private func linesToPath(lines: [LineModel]) -> CGMutablePath {
        let mutablePath = CGMutablePath()
        for line in lines {
            mutablePath.addPath(line.path)
        }
        return mutablePath
    }
}
