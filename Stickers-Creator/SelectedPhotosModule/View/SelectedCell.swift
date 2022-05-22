//
//  SelectedCells.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.05.2022.
//

import Foundation
import UIKit

class SelectedCell: UICollectionViewCell {
    private var imageView = UIImageView()
    
    func setImage(image: UIImage) {
        addSubview(imageView)
        configureImageView()
        setImageConstraints()
        imageView.image = image
    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(imageView)
//        configureImageView()
//        setImageConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//        self.backgroundColor = .blue
//        //addSubview(imageView)
//        //setWidth(frame: frame)
//        //configureImageView()
//        setImageConstraints()
//    }
    

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func set(image: UIImage) {
        self.imageView.image = image
    }
    
    private func configureImageView() {
        //imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        imageView.contentMode = .center
        imageView.clipsToBounds = true
    }
    
    private func setImageConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.center = self.center
        imageView.contentMode = .scaleAspectFit
        //imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        //imageView.heightAnchor.constraint(equalToConstant: imageView.bounds.height).isActive = true
        //imageView.widthAnchor.constraint(equalToConstant: imageView.bounds.width).isActive = true
    }
    
}
