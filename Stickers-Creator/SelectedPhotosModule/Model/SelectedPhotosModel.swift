//
//  Model.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 23.05.2022.
//

import Foundation
import UIKit

struct SelectedPhotosModel {
    
    
    private var pkAdapter = PhotoKitAdapter()
    
    var images:[UIImage] { pkAdapter.images }
    
    
}
