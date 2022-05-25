//
//  SelectedCells.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//

import Foundation
import UIKit

class SelectedCell: UICollectionViewCell {
    private var photo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImage()
        addSubview(photo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage?) {
        self.photo.image = image
    }
    
    private func configureImage() {
        photo.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        photo.clipsToBounds = true
        photo.contentMode = .scaleAspectFill
    }
}
