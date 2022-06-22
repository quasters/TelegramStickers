//
//  File.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import Foundation

enum BottomButtonImageNames: String {
    case Pencil = "pencil.circle"
    case Eraser = "scissors.circle"
    case Ruler = "circle.bottomhalf.filled"
    case Eye = "eye.circle"
    case Folder = "folder.circle"
    
    static let allValues = [Pencil, Eraser, Ruler, Eye, Folder]
    static var disabledValues = [true, false, false, false, false]
}
