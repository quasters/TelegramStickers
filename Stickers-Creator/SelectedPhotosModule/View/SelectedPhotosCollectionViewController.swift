//
//  SelectedPhotosViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import UIKit
import PhotosUI


class SelectedPhotosCollectionViewController: UICollectionViewController {
    var presenter: SelectedPhotosPresenterInputProtocol?
    
    private let cellIdentifier = "Cell"
    //var width: CGFloat?
    let itemsPerRow: CGFloat = 3
    let sectionInserts = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    var fetchResult = PHFetchResult<PHAsset>() {
        didSet {
            if fetchResult.count == 0 {
                self.collectionView.showEmptyCollectionNotice()
            } else {
                self.collectionView.restore()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegisters()
        configureNavigationBar()
        startFetching()
    }
    
    func setupRegisters() {
        PHPhotoLibrary.shared().register(self)
        self.collectionView!.register(SelectedCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension SelectedPhotosCollectionViewController: SelectedPhotosViewPresenterOutputProtocol {
    @objc func tapOnCloseButton() {
        presenter?.moveToRoot(for: self)
    }
    
    func choseImage(image: UIImage) {
        presenter?.moveToRoot(for: self, image: image)
    }
}


// MARK: UICollectionViewDataSource
extension SelectedPhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let originalCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = originalCell as? SelectedCell else { originalCell.backgroundColor = .gray; return originalCell }
        
        let asset = self.fetchResult[indexPath.row]
        let manager = PHImageManager.default()
        let _ = manager.requestImage(for: asset,
                                         targetSize: CGSize(width: 400, height: 400),
                                         contentMode: .aspectFit, options: nil) { image, _ in
            cell.setImage(image: image)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.fetchResult[indexPath.row]
        let manager = PHImageManager.default()
        var image = UIImage()
        let _ = manager.requestImage(for: asset,
                                         targetSize: CGSize(width: 400, height: 400),
                                         contentMode: .aspectFit, options: nil) { img, _ in
            guard let img = img else { return }
            image = img
            self.choseImage(image: image)
        }
        //print(image.size)
    }
}


// MARK: PHPhotoLibraryChangeObserver
extension SelectedPhotosCollectionViewController: PHPhotoLibraryChangeObserver {
    private func startFetching() {
        let fetchResultOptions = PHFetchOptions()
        fetchResultOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: fetchResultOptions)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            guard let collectionView = self.collectionView else { return }
            if let changes = changeInstance.changeDetails(for: self.fetchResult) {
                self.fetchResult = changes.fetchResultAfterChanges
                if changes.hasIncrementalChanges {
                    collectionView.performBatchUpdates {
                        if let removed = changes.removedIndexes {
                            collectionView.deleteItems(at: removed.map{ IndexPath(item: $0, section: 0) })
                        }
                        if let inserted = changes.insertedIndexes, inserted.count > 0 {
                            collectionView.insertItems(at: inserted.map{ IndexPath(item: $0, section: 0) })
                        }
                        if let changed = changes.changedIndexes, changed.count > 0 {
                            collectionView.reloadItems(at: changed.map{ IndexPath(item: $0, section: 0) })
                        }
                        changes.enumerateMoves { fromIndex, toIndex in
                            collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                    to: IndexPath(item: toIndex, section: 0))
                        }
                    }
                } else {
                    collectionView.reloadData()
                }
            }
        }
    }
}

// MARK: - Configuration NavigationBar
extension SelectedPhotosCollectionViewController {
    private func configureNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapOnCloseButton))
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
    
    private func pickMorePhotos() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
}

// MARK: - Configuration Cells
extension SelectedPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - EmptyCollectionNotice
extension UICollectionView {
    func showEmptyCollectionNotice() {
        let width = self.bounds.width
        let height = self.bounds.height
        
        let textVC = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let title = setEmptyCollectionMessage("You have no Photos", size: 30, offset: -37)
        let message = setEmptyCollectionMessage("You've given access to only a select number of photos. You can manage it with the Edit button above.", size: 17, offset: +25)
        textVC.addSubview(title)
        textVC.addSubview(message)
        self.backgroundView = textVC
    }
    
    private func setEmptyCollectionMessage(_ message: String, size: CGFloat, offset: CGFloat) -> UILabel {
        let width = self.bounds.width - 40
        let height = self.bounds.height
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Arial", size: size)
        messageLabel.sizeToFit()
        messageLabel.center.x = self.center.x
        messageLabel.center.y = self.center.y + offset
        return messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}