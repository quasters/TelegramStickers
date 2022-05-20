//
//  SelectedPhotosViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import UIKit
import Photos

class SelectedPhotosViewController: UIViewController, PHPhotoLibraryChangeObserver {
    var presenter: SelectedPhotosPresenter?
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        let fetchResultChangeDetails = changeInstance.changeDetails(for: asset)
//        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)

    }

}
