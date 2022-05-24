//
//  SelectedCells.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//

import Foundation
import UIKit

class SelectedCell: UICollectionViewCell {
    var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButton(image: UIImage?) {
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
    }
    
    private func configureButton() {
        button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        button.imageView?.contentMode = .scaleAspectFill
    }
}
