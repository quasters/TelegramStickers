//
//  SelectedCells.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//

import Foundation
import UIKit

class SelectedCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
}
