//
//  DrowManager.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 31.05.2022.
//

import Foundation
import UIKit

class DrawManager: UIImageView {
    var path = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    var cropImage = UIImage()


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first as UITouch?{
           let touchPoint = touch.location(in: self)
           print("touch begin to : \(touchPoint)")
           //path.move(to: touchPoint)
       }
   }

   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first as UITouch?{
           let touchPoint = touch.location(in: self)
           print("touch moved to : \(touchPoint)")
//           path.addLine(to: touchPoint)
//           addNewPathToImage()
       }
   }

   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first as UITouch?{
           let touchPoint = touch.location(in: self)
           print("touch ended at : \(touchPoint)")
//           path.addLine(to: touchPoint)
//           addNewPathToImage()
//           path.close()
       }
   }
    func addNewPathToImage(){
//       shapeLayer.path = path.cgPath
//       shapeLayer.strokeColor = strokeColor.cgColor
//       shapeLayer.fillColor = UIColor.clear.cgColor
//       shapeLayer.lineWidth = lineWidth
//       YourimageView.layer.addSublayer(shapeLayer)
   }
//      func cropImage(){
//
//       UIGraphicsBeginImageContextWithOptions(YourimageView.bounds.size, false, 1)
//       tempImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
//       let newImage = UIGraphicsGetImageFromCurrentImageContext()
//       UIGraphicsEndImageContext()
//       self.cropImage = newImage!
//       }

//
//       @IBAction func btnCropImage(_ sender: Any) {
//            cropImage()
//       }
}
