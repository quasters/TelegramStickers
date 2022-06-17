//
//  DrawView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit


//protocol DrawViewDelegate: AnyObject {
//    func setMask(_ mask: UIImage?)
//}

class DrawView: UIImageView {
//    public weak var delegate: DrawViewDelegate?

    private var lineWidth: CGFloat = CGFloat(30)
    private var isEraseLine = false
    
    private var lastPoint: CGPoint!

    private var currentPath: UIBezierPath!
    private var lines = [LineModel]()
    
    var a = 0 // FIXME: - remove test variable
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)
                
        currentPath = UIBezierPath()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let currentPoint = touch.location(in: self)
        
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        let line = LineModel(path: currentPath.cgPath, width: lineWidth, isErase: isEraseLine)
        lines.append(line)
        LinesManager.shared.addLine(line: line)
        
//        let imageMask = self.getImageMask(line: line)
//        self.delegate?.setMask(imageMask)
        a += 1
    }

    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        currentPath.move(to: fromPoint)
        currentPath.addLine(to: toPoint)
        
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(self.frame)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))

        context.move(to: fromPoint)
        context.addLine(to: toPoint)
              
        if a > 6 {
            isEraseLine = true
        }
        
        context.setBlendMode( !isEraseLine ? .color : .clear)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.white.cgColor)

        context.strokePath()

        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 0.5
    }

}


