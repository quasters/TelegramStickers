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
    var lineWidth: CGFloat!
    var lineColor: UIColor!
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    var path: UIBezierPath!
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        endPoint = touch?.location(in: self)
        linesManager.addLine(line: LineModel(start: startPoint, end: endPoint, size: 10))
        
        path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        startPoint = endPoint
        drawShapeLayer()
    }
    
    private func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = CGColor(red: 0, green: 0, blue: 100, alpha: 0.3) // FIXME: - change color
        shapeLayer.lineWidth = CGFloat(10)
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
}
