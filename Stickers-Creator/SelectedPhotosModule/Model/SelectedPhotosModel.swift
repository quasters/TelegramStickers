//
//  Model.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 23.05.2022.
//

import Foundation
import Photos
import UIKit

struct SelectedPhotosModel {
    var photos = [UIImage?]()
    var fetchResult: PHFetchResult<PHAsset>?
}
