//
//  infoCells.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 18.05.2022.
//

import Foundation
import UIKit

class InfoCell: UITableViewCell {
    private var usernameLabel = UILabel()
    private var iconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(usernameLabel)
        
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func set(username: String, imageName: String) {
        self.usernameLabel.text = username
        self.iconImageView.image = UIImage(named: imageName)
    }
    
    
    private func configureImageView() {
        iconImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
    }
    
    private func configureTitleLabel() {
        usernameLabel.numberOfLines = 0
        usernameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setImageConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: iconImageView.bounds.height).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: iconImageView.bounds.width).isActive = true
    }
    
    private func setLabelConstraints() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 7).isActive = true
    }
}
