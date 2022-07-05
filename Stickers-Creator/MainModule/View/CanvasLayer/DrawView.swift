//
//  DrawView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

class DrawView: UIImageView {
    private var lineWidth: CGFloat = CGFloat(30)
    private var isEraserLine = false
    
    private var isRuler = false
    private var firstRulerPoint: CGPoint!
    private var rulerPath: UIBezierPath!
    private var imageBeforeRuller: UIImage?
    
    private var lastPoint: CGPoint!
    private var currentPath: UIBezierPath!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if isRuler {
            rulerPath = UIBezierPath()
            firstRulerPoint = touch.location(in: self)
            imageBeforeRuller = self.image
        }

        lastPoint = touch.location(in: self)
        currentPath = UIBezierPath()

        drawLine(from: lastPoint, to: lastPoint)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        
        guard let fromPoint = isRuler ? firstRulerPoint : lastPoint else { return }
        drawLine(from: fromPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        let linePath: CGPath
        
        if isRuler {
            rulerPath.move(to: firstRulerPoint)
            rulerPath.addLine(to: lastPoint)
            linePath = rulerPath.cgPath
        } else {
            linePath = currentPath.cgPath
        }
        
        let line = LineModel(path: linePath, width: lineWidth, isErase: isEraserLine)
        LinesManager.shared.addLine(line: line)
    }

    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        if !isRuler {
            currentPath.move(to: fromPoint)
            currentPath.addLine(to: toPoint)
        } else {
            self.image = imageBeforeRuller
        }
        
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
                
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
            
        context.setBlendMode( !isEraserLine ? .multiply : .clear)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.blue.cgColor)

        context.strokePath()

        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.alpha = 0.25
    }
}

extension DrawView: DrawToolsSettingsDelegate {
    func setLineWidth(_ width: CGFloat) {
        self.lineWidth = width
    }
    
    func setTool(_ tool: BottomButtonImageNames) {
        switch tool {
        case .Pencil:
            self.isEraserLine = false
        case .Eraser:
            self.isEraserLine = true
        case .Ruler:
            self.isRuler = !self.isRuler
        default: return
        }
    }
}


