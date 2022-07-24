//
//  ChangesResultViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import UIKit

// FIXME: - fix size of saved image to 512xY
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
        
        guard let ciImage = CIImage(image: image)?.unpremultiplyingAlpha() else { return }
        let uiImage = UIImage(ciImage: ciImage)
        
        guard let imagePNGData = uiImage.pngData() else { return }
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
        var image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        if let data = image?.pngData() {
            image = UIImage(data: data)
        }
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
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageDidLoad), nil)
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
