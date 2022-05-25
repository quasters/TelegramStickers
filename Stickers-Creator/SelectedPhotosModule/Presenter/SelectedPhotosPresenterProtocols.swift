//
//  SelectedPhotosPresenterProtocols.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 25.05.2022.
//

import Foundation
import UIKit

protocol SelectedPhotosPresenterInputProtocol: AnyObject {
    init(view: SelectedPhotosViewPresenterOutputProtocol, router: RouterProtocol)
    func tapOnEditButton()
    func selectMorePhotos()
    func changedLibrary(currentQuantity: Int)
    func moveToSettings()
    func moveToRoot(for view: UICollectionViewController)
    func moveToRoot(for view: UICollectionViewController, image: UIImage)
}

protocol SelectedPhotosViewPresenterOutputProtocol: AnyObject {
    func showNotice()
    func hideNotice()
    func showActionSheet()
    func choseImage(image: UIImage)
    func pickMorePhotos()
}

protocol SelectedPhotosPresenterDelegate {
    func setImage(image: UIImage)
}
