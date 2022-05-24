//
//  SelectedPhotosViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import UIKit
import PhotosUI


class SelectedPhotosViewController: UICollectionViewController {
    var presenter: SelectedPhotosPresenterInputProtocol?
    var width: CGFloat?
    
    let itemsPerRow: CGFloat = 3
    let sectionInserts = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    
    var assets = [PHAsset]()
    var fetchResult: PHFetchResult<PHAsset>?
    
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        //var register = self.presenter?.changeObserverRegisterClass()
        PHPhotoLibrary.shared().register(self)
        self.startFetching()
        //startFetching()
        self.collectionView!.register(SelectedCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
}

extension SelectedPhotosViewController: SelectedPhotosViewPresenterOutputProtocol {
    func updateCollection() {
        self.collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension SelectedPhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count //presenter?.getPhotos().count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let originalCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = originalCell as? SelectedCell else { originalCell.backgroundColor = .gray; return originalCell }
        
        let asset = assets[indexPath.row]
        let manager = PHImageManager.default()

        let _ = manager.requestImage(for: asset,
                                         targetSize: CGSize(width: 400, height: 400),
                                         contentMode: .aspectFit, options: nil) { image, _ in
            cell.setButton(image: image)
            cell.button.addTarget(self, action: #selector(self.backToMainVC(sender:)), for: .touchUpInside)
        }
        
        //let image = presenter?.getPhotos()[indexPath.row]
        //cell.setButton(image: image)
        //cell.button.addTarget(self, action: #selector(self.backToMainVC(sender:)), for: .touchUpInside)
        return cell
    }
}


// MARK: PHPhotoLibraryChangeObserver
extension SelectedPhotosViewController: PHPhotoLibraryChangeObserver {
    func startFetching() {
        
        PHPhotoLibrary.shared().register(self)
        let fetchResultOptions = PHFetchOptions()
        fetchResultOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: fetchResultOptions)

        fetchResult?.enumerateObjects { asset, count, stop in
            self.assets.append(asset)
        }
        self.collectionView.reloadData()
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.fetchResult!) else { return }
        DispatchQueue.main.async {
            self.fetchResult = changes.fetchResultAfterChanges
            self.assets = []
            self.fetchResult?.enumerateObjects { object, count, stop in
                self.assets.append(object)
            }
            self.collectionView.reloadData()
        }
    }
    
//    func startFetching() {
//        let fetchResultOptions = PHFetchOptions()
//        fetchResultOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        var photos = [UIImage?]()
//        DispatchQueue.main.async {
//            let fetchResult = PHAsset.fetchAssets(with: fetchResultOptions)
//            fetchResult.enumerateObjects { asset, count, stop in
//                let photo = self.getImage(asset: asset)
//                photos.append(photo)
//            }
//            self.presenter?.setPhotos(photos: photos, fetchResult: fetchResult)
//        }
//    }
//
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        guard let presenter = presenter else { return }
//
//        var photos = presenter.getPhotos()
//        var fetchResult = presenter.getFetchResult()
//
//        guard let changes = changeInstance.changeDetails(for: fetchResult!) else { return }
//        if !changes.hasIncrementalChanges { return }
//
//        DispatchQueue.main.async {
//            fetchResult = changes.fetchResultAfterChanges
//            if let removeIndexes = changes.removedIndexes {
//                for removeIndex in removeIndexes {
//                    photos.remove(at: removeIndex)
//                }
//            }
//            if let insertIndexes = changes.insertedIndexes {
//                for insertIndex in insertIndexes {
//                    guard let asset = fetchResult?[insertIndex] else { return }
//                    let image = self.getImage(asset: asset)
//                    photos.insert(image, at: insertIndex)
//                }
//            }
//            if let changedIndexes = changes.changedIndexes {
//                for changedIndex in changedIndexes {
//                    guard let asset = fetchResult?[changedIndex] else { return }
//                    photos[changedIndex] = self.getImage(asset: asset)
//                }
//            }
//            changes.enumerateMoves { fromIndex, toIndex in
//                guard let asset = fetchResult?[toIndex] else { return }
//                photos.remove(at: fromIndex)
//                let image = self.getImage(asset: asset)
//                photos.insert(image, at: toIndex)
//            }
//            print(photos.count)
//            presenter.setPhotos(photos: photos, fetchResult: fetchResult)
//        }
//    }
//
//    private func getImage(asset: PHAsset) -> UIImage? {
//        let manager = PHImageManager.default()
//        var photo: UIImage?
//        let _ = manager.requestImage(for: asset,
//                                     targetSize: CGSize(width: 400, height: 400),
//                                     contentMode: .aspectFit, options: nil) { image, _ in
//            photo = image
//        }
//        return photo
//    }
}

// MARK: - Configuration NavigationBar
extension SelectedPhotosViewController {
    func configureNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMainVC))
        let leftButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showActionSheet))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    // Configure Action Sheet to do with Selecting Photo
    @objc func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        alert.addAction(UIAlertAction(title: "Select More Photos", style: .default, handler: { (UIAlertAction) in
            self.pickMorePhotos()
        }))
        alert.addAction(UIAlertAction(title: "Change Settings", style: .default, handler: { (UIAlertAction) in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func pickMorePhotos() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
// FIXME: - add sending image
    @objc func backToMainVC(sender: UIButton? = nil) {
        let _ = sender?.imageView?.image
        presenter?.tapOnCloseButton(for: self)
    }
}

// MARK: - Configuration Cells
extension SelectedPhotosViewController: UICollectionViewDelegateFlowLayout {
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let peddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - peddingWidth
        let width = availableWidth / itemsPerRow
        return CGSize(width: width, height: width)
    }

    // Cell Boarders
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    // Spacing between lines
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    // Distance between objects
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
