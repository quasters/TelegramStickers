//
//  ImageLayers.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

struct MainModel { 
    var photo: UIImage? {
        didSet {
            mask = nil
        }
    }
    var mask: UIImage?
}
