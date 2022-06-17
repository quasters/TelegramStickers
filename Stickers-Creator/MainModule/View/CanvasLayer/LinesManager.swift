//
//  LinesManager.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 16.06.2022.
//

import Foundation
import UIKit

protocol LinesManagerButtonSettingsDelegate: AnyObject {
    func reloadActivityStatus(clearStatus: Bool, backStatus: Bool, forwardStatus: Bool)
}

protocol DrawViewDelegate: AnyObject {
    func setMask(_ mask: UIImage?)
}

class LinesManager {
    static var shared = LinesManager()
    private init(){}
    
    public var buttonSettingsDelegate: LinesManagerButtonSettingsDelegate?
    public var delegate: DrawViewDelegate?
    
    private var savedLines = [LineModel]()
    private var imageView: UIImageView?

    private var linesCount: Int = 0 {
        didSet {
            self.currentLine = linesCount
        }
    }
    private var currentLine: Int = 0
    
    func setImageView(imageView: UIImageView) {
        savedLines.removeAll()
        linesCount = 0
        self.imageView = imageView
    }
    
    func addLine(line: LineModel) {
        linesCount = currentLine
        savedLines.removeSubrange(currentLine ..< savedLines.endIndex)
        savedLines.append(line)
        linesCount += 1
        //sendButtonsStatus()
        reloadView()
    }

    func clearCanvas() {
        currentLine = 0
        reloadView()
    }
    
    func previusLine() {
        currentLine -= 1
        reloadView()
    }

    func nextLine() {
        currentLine += 1
        reloadView()
    }
    
    private func reloadView() {
        printLines()
        sendButtonsStatus()
    }
    
    private func printLines() {
        guard let imageView = self.imageView else { return }
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        context.clear(imageView.bounds)
        
        
        for (index, line) in savedLines.enumerated() where index < currentLine {
            context.addPath(line.path)
            context.setBlendMode( !line.isErase ? .color : .clear )
            context.setLineWidth(line.width)
            context.setStrokeColor(UIColor.white.cgColor)
            context.setLineCap(CGLineCap.round)
            context.setLineJoin(CGLineJoin.round)
            context.strokePath()
        }
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = 0.5
        UIGraphicsEndImageContext()
        
        // FIXME: - remove
        let imageMask = self.getImageMask(lines: savedLines)
        self.delegate?.setMask(imageMask)
    }
    
    private func sendButtonsStatus() {
        let clearStatus = currentLine != 0
        let backStatus = currentLine != 0
        let forwardStatus = currentLine < linesCount
        buttonSettingsDelegate?.reloadActivityStatus(clearStatus: clearStatus, backStatus: backStatus, forwardStatus: forwardStatus)
    }
    
    func getImageMask(lines: [LineModel]) -> UIImage? {
        guard let bounds = self.imageView?.bounds else { return nil }
        let imageMask = ImageMaskCreator.shared.create(frame: bounds, lines: lines, currentLine: currentLine)
        return imageMask
    }
}

