//
//  DrawView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

class DrawView: UIImageView {
    private var imageFrame: CGRect?
    private let linesManager = LinesManager()
    private var lineWidth = CGFloat(15)
    private var lineColor = UIColor.red.cgColor
    private var lastPoint: CGPoint!
    private var endPoint: CGPoint!

    private var currentLayer: CAShapeLayer!
    private var currentPath: UIBezierPath!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageFrame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)

        currentLayer = CAShapeLayer()
        currentPath = UIBezierPath()

        self.layer.addSublayer(currentLayer)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let imageFrame = imageFrame else { return }

        let currentPoint = touch.location(in: self)
        if !imageFrame.contains(currentPoint) { return }
        
        drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
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

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        bezierPaths.append(currentPath)
//    }
    
//    func clipImage(from fromPoint: CGPoint, to toPoint: CGPoint) {
//        currentPath.move(to: fromPoint)
//        currentPath.addLine(to: toPoint)
//
//
//
//        UIGraphicsBeginImageContext(self.frame.size)
//        //UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 1.0)
//        let currentContext = UIGraphicsGetCurrentContext()
//        //currentContext?.move(to: fromPoint)
//        currentContext?.addPath(currentPath.cgPath)
//        //currentContext?.addRect(CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        currentContext?.addLine(to: toPoint)
//        currentContext?.setFillColor(UIColor.clear.cgColor)
//        //currentContext.draw
//        currentContext?.drawPath(using: .stroke)
//
//
//        //currentContext?.clip(using: .evenOdd)
//
//        //self.image?.draw(at: .zero)
//
//        self.image = UIGraphicsGetImageFromCurrentImageContext();
//        //UIGraphicsEndImageContext()
//    }
    
}


