//
//  DrawView.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

class DrawView: UIImageView {
    let linesManager = LinesManager()
    var lineWidth = CGFloat(10)
    var lineColor = CGColor(red: 0, green: 0, blue: 100, alpha: 0.3)
    var lastPoint: CGPoint!
    var endPoint: CGPoint!
    

    
    var currentLayer: CAShapeLayer!
    var bezierPaths = [UIBezierPath]()
    var currentPath: UIBezierPath!
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.strokePath()
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
        let currentPoint = touch.location(in: self)
        //drawLine(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
//
//
//
//    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
//        currentPath.move(to: fromPoint)
//        for bezierPath in bezierPaths {
//            if bezierPath.contains(toPoint) { return }
//        }
//
//        currentPath.addLine(to: toPoint)
//        currentLayer.path = currentPath.cgPath
//        currentLayer.strokeColor = lineColor
//        currentLayer.lineWidth = lineWidth
//        currentLayer.lineCap = .round
//        currentLayer.lineJoin = .round
//        print("a - \(currentPath.isEmpty)")
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        bezierPaths.append(currentPath)
//    }
}


