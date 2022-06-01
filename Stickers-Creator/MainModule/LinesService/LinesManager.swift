//
//  LinesManager.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

class LinesManager {
    private var savedLines = [LineModel]()
    private var currentLines = [LineModel]()
    
    func addLine(line: LineModel) {
        currentLines.append(line)
    }

    func removeLines() {
        savedLines = currentLines
        currentLines.removeAll()
    }
    
    func previousLine() {
        let line = currentLines.removeLast()
        savedLines.append(line)
    }
    
    func nextLine() {
        let line = savedLines.removeLast()
        currentLines.append(line)
    }
    
    func printLines(in view: UIView) {
        for line in currentLines {
            let path = UIBezierPath()
            path.move(to: line.start)
            path.addLine(to: line.end)
            drawShapeLayer(path, line.size, view)
        }
    }
        
    private func drawShapeLayer(_ path: UIBezierPath, _ lineSize: Float, _ view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = CGColor(red: 0, green: 0, blue: 100, alpha: 0.3) // FIXME: - change color
        shapeLayer.lineWidth = CGFloat(lineSize)
        shapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
        view.setNeedsDisplay()
    }
    
    func deleteAllLines(in view: UIView) {
        guard let sublayers = view.layer.sublayers else { return }
        for sublayer in sublayers {
            sublayer.removeFromSuperlayer()
        }
    }
}
