//
//  Model.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 23.05.2022.
//

import Foundation
import UIKit

struct SelectedPhotosModel {
    
    
    var adapter: PhotoKitAdapter
    
    var images: [UIImage]? //{ pkAdapter.images }
    
    init(adapter: PhotoKitAdapter, images: [UIImage]?) {
        self.images = images
        self.adapter = adapter
    }
    
}
