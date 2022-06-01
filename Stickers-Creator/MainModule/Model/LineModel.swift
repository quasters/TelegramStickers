//
//  LineModel.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

struct LineModel {
    var start: CGPoint
    var end: CGPoint
    var size: Float
    
    init(start: CGPoint, end: CGPoint, size: Float) {
        self.start = start
        self.end = end
        self.size = size
    }
}
