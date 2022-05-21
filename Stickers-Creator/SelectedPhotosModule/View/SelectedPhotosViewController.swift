//
//  SelectedPhotosViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import UIKit
import Photos

class SelectedPhotosViewController: UINavigationController, PHPhotoLibraryChangeObserver {
    var presenter: SelectedPhotosPresenter?
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
     
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //PHPhotoLibrary.shared().register(self)
        
        var image = UIImageView()
        image.image = UIImage(named: "tg-icon")
        image.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        image.center = view.center
        view.addSubview(image)
        
    }

}

extension SelectedPhotosViewController: SelectedPhotosViewPresenterOutputProtocol {
    
}

extension SelectedPhotosViewController: UINavigationControllerDelegate {
    
}
