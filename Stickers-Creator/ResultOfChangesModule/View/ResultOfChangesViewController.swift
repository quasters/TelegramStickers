//
//  ChangesResultViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import UIKit
import AlamofireImage

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
        
        guard let image = maskedImage?.cropAlpha() else { return }
        
        presenterImageView.image = image

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
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let maskView = UIImageView()
        maskView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mask.size)
        maskView.contentMode = .scaleAspectFit
        maskView.image = mask
        
        imageView.mask = maskView
        
        let finalImage = returnFinalImage(contentView: imageView)
        
        return finalImage
    }
    
    private func returnFinalImage(contentView: UIImageView) -> UIImage? {
        let size = CGSize(width: CGFloat(contentView.frame.size.width), height: CGFloat(contentView.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
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
        if let image = presenterImageView.image {
            var size = CGSize(width: image.size.width, height: image.size.height)
            let widthRatio = 512 / image.size.width
            let heightRatio = 512 / image.size.height
            
            if (size.width > size.height) {
                size.width *= widthRatio
                size.height *= widthRatio
            } else {
                size.width *= heightRatio
                size.height *= heightRatio
            }
            
            let writeImage = image.af.imageAspectScaled(toFit: size)
            
            guard let ciImage = CIImage(image: writeImage)?.unpremultiplyingAlpha() else { return }
            let ciContext = CIContext()
            
            guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return }
            let uiImage = UIImage(cgImage: cgImage)
            
            guard let imagePNGData = uiImage.pngData() else { return }
            guard let imagePNG = UIImage(data: imagePNGData) else { return }

            UIImageWriteToSavedPhotosAlbum(imagePNG, self, #selector(imageDidLoad), nil)
        }
    }
    
    
    @objc private func imageDidLoad(_ im: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        var title: String
        var message: String
        if let err = error {
            title = "Something went wrong"
            message = "The sticker can't be uploaded to your Photo Library. Error: \(err)"
            return
        } else {
            title = "Done!"
            message = "The sticker has been uploaded to your Photo Library."
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}
