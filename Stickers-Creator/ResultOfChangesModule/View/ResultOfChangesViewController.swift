//
//  ChangesResultViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import UIKit

class ResultOfChangesViewController: UIViewController {

    var presenter: ResultOfChangesPresenterInputProtocol?
    let presenterImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        configurePresenterImageView()
        configureNavigation()
    }
    
    private func configurePresenterImageView() {
        presenterImageView.contentMode = .scaleAspectFit
        let maskedImage = setUpImageView()
        let image = maskedImage?.cropAlpha()
        
        guard let imagePNGData = image?.pngData() else { return } //maskedImage!.pngData()
        let imagePNG = UIImage(data: imagePNGData)

        presenterImageView.image = imagePNG

        view.addSubview(presenterImageView)
        addPresenterImageViewConstraints()
    }
    
    private func addPresenterImageViewConstraints() {
        presenterImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            presenterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            presenterImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            presenterImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            presenterImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -30)
        ])
    }
    
    private func setUpImageView() -> UIImage? {
        guard let image = presenter?.getImage() else { return nil }
        guard let mask = presenter?.getMask() else { return nil }
        
        let imageView = UIImageView()
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let maskView = UIImageView()
        maskView.frame = view.bounds
        maskView.contentMode = .scaleAspectFit
        maskView.image = mask
        
        imageView.mask = maskView
        
        let finalImage = returnFinalImage(contentView: imageView)!
        
        return finalImage
    }
    
    private func returnFinalImage(contentView: UIImageView) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(contentView.frame.size.width), height: CGFloat(contentView.frame.size.height)))
        contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func configureNavigation() {
        let infoBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
        infoBarButtonItem.isEnabled = presenterImageView.image != nil
        self.navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    @objc private func tappedDoneButton() {
        presenter?.tappedDoneButton()
    }
}
    

    

extension ResultOfChangesViewController: ResultOfChangesPresenterOutputProtocol {
    func saveImage() {
        // FIXME: - Incorrect saving png
        if let image = presenterImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
