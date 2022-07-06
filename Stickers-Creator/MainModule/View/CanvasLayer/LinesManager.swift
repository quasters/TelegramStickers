//
//  LinesManager.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 16.06.2022.
//

import Foundation
import UIKit

class LinesManager {
    static var shared = LinesManager()
    private init(){}
    
    public var buttonSettingsDelegate: LinesManagerButtonSettingsDelegate?
    
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
        
        sendButtonsStatus()
    }

    func clearCanvas() {
        currentLine = 0
        reloadView(isNext: false)
    }
    
    func previusLine() {
        currentLine -= 1
        reloadView(isNext: false)
    }

    func nextLine() {
        currentLine += 1
        reloadView(isNext: true)
    }
    
    private func reloadView(isNext: Bool) {
        printLines(isNext: isNext)
        sendButtonsStatus()
    }
    
    private func printLines(isNext: Bool) {
        guard let imageView = self.imageView else { return }
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        if !isNext {
            context.clear(imageView.bounds)
            for (index, line) in savedLines.enumerated() where index < currentLine {
                setUpContext(context: context, line: line)
            }
        } else {
            let line = savedLines[currentLine - 1]
            setUpContext(context: context, line: line)
        }
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = 0.25
        UIGraphicsEndImageContext()
    }
    
    private func setUpContext(context: CGContext, line: LineModel) {
        context.addPath(line.path)
        context.setBlendMode( !line.isErase ? .color : .clear )
        context.setLineWidth(line.width)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
        context.strokePath()
    }
    
    private func sendButtonsStatus() {
        let clearStatus = currentLine != 0
        let backStatus = currentLine != 0
        let forwardStatus = currentLine < linesCount
        buttonSettingsDelegate?.reloadActivityStatus(clearStatus: clearStatus, backStatus: backStatus, forwardStatus: forwardStatus)
    }
}

extension LinesManager: MainPresenterStickerSenderDelegate {
    func getImageMask() -> UIImage? {
        guard let bounds = self.imageView?.bounds else { return nil }
        let imageMask = ImageMaskCreator.shared.create(frame: bounds, lines: savedLines, currentLine: currentLine)
        return imageMask
    }
}
