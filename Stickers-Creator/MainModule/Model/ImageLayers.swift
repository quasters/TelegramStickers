//
//  ImageLayers.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation

struct Photos {
    static var isAllowCamera = false
    static var isAllowPhotoLibrary = false
    var savedImages: [SavedImage]
}

struct SavedImage {
    var path: String
}
