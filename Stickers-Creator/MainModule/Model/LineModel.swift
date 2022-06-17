//
//  LineModel.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 30.05.2022.
//

import Foundation
import UIKit

struct LineModel {
    var path: CGPath
    var width: CGFloat
    var isErase: Bool
    
    init(path: CGPath, width: CGFloat, isErase: Bool) {
        self.path = path
        self.width = width
        self.isErase = isErase
    }
}
