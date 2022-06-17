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
    public weak var delegate: DrawViewDelegate?

    private var lineWidth: CGFloat = CGFloat(30)
    private var isEraseLine = false
    private var lineColor: CGColor = UIColor.white.cgColor
    private var lastPoint: CGPoint!
    private var endPoint: CGPoint!

    private var maskLayer = CAShapeLayer()
    private var currentPath: UIBezierPath!
    private var lines = [LineModel]()
    
    //private var paths = CGMutablePath()

    var a = 0
    
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
        //self.paths.addPath(self.currentPath.cgPath)
        //paths.append(currentPath.cgPath)
        
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
        
       if a > 4 {
            isEraseLine = true
        }
//            //lineColor = UIColor.clear.cgColor
//            context.setBlendMode(.clear)
//        } else {
//            context.setBlendMode(.color)
//        }
//
      
        context.setBlendMode( !isEraseLine ? .color : .clear)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor)

        context.strokePath()

        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = 0.5
        
    }
    
    private func getImageMask(line: LineModel) -> UIImage? {
        //let size = CGSize(width: self.bounds.width, height: self.bounds.height)

        let imageMask = ImageMaskCreator.shared.create(frame: self.bounds, lines: lines, currentLine: lines.endIndex)

        return imageMask
    }
}


