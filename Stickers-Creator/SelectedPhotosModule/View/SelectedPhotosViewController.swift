//
//  SelectedPhotosViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import UIKit
import PhotosUI


class SelectedPhotosViewController: UICollectionViewController {
    var presenter: SelectedPhotosPresenter?
    var width: CGFloat?
    
    let itemsPerRow: CGFloat = 3 // Количество ячеек в ряду
    let sectionInserts = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) // Отступы
    
    var photos = [PHAsset]()
    //var adapter = PhotoKitAdapter()
    //var model: SelectedPhotosModel?
    //
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    
    //var allPhotos:PHFetchResult<PHAsset>?
            
    //
    
    
    override func  viewWillLayoutSubviews() {
//        let image = UIImageView()
//        image.image = UIImage(named: "tg-icon")
//        image.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        image.contentMode = .scaleToFill
//        image.center = view.center
//        view.addSubview(image)
//        createCollection()
//        getPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        self.collectionView!.register(SelectedCell.self, forCellWithReuseIdentifier: "id")
        startFetching()
        //PHPhotoLibrary.shared().register(self)
        //model = SelectedPhotosModel(adapter: phKitAdapter, images: photos)
    }

    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //DispatchQueue.main.async {
            //print("----------------\(self.adapter.images.count)")
            //self.adapter.getImages()
        //}
        print("number of items: \(photos.count)")
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let originalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath)
        guard let cell = originalCell as? SelectedCell else { originalCell.backgroundColor = .gray; return originalCell }
        

        
        let asset = photos[indexPath.row]
        let manager = PHImageManager.default()

        let _ = manager.requestImage(for: asset,
                                         targetSize: CGSize(width: 400, height: 400),
                                         contentMode: .aspectFit, options: nil) { image, _ in
            cell.setButton(image: image, action: <#T##UIAction#>)
        }

        //cell.setImage(image: image)
        //print(image)
        return cell
    }

    
    
    func pickMorePhotos() {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
}


extension SelectedPhotosViewController: UICollectionViewDelegateFlowLayout {
    //Определяет размер ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let peddingWidth = sectionInserts.left * (itemsPerRow + 1) //Длина всех отступов в ряду, для 2 ячеек = 3*20=60
        let availableWidth = collectionView.frame.width - peddingWidth //Доступная ширина
        let width = availableWidth / itemsPerRow //ширина одного объекта
        return CGSize(width: width, height: width)
    }

    //Устанавливает границы для ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    //Устанавливает отсупы между линиями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    //Устанавливает растояние между самими объектами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}



extension SelectedPhotosViewController {
    // MARK: - Configuration NavigationBar
    func configureNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMainVC))
        let leftButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showActionSheet))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func backToMainVC() {
        presenter?.tapOnCloseButton(for: self)
    }
    
    // MARK: - Configure Action Sheet to do with Selecting Photo 
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
}


extension SelectedPhotosViewController: SelectedPhotosViewPresenterOutputProtocol {
    
}


extension SelectedPhotosViewController: PHPhotoLibraryChangeObserver {
    func startFetching() {
        PHPhotoLibrary.shared().register(self)
        let fetchResultOptions = PHFetchOptions()
        fetchResultOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: fetchResultOptions)

        fetchResult?.enumerateObjects { object, count, stop in
            self.photos.append(object)
        }
        self.collectionView.reloadData()
        
        //self.updateImages()
        //print("fetch images \(self.images.count)")
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        //DispatchQueue.main.async {
        //print("fetch result before: \(fetchResult)")
        guard let changes = changeInstance.changeDetails(for: self.fetchResult!) else { return }
        DispatchQueue.main.async {
            self.fetchResult = changes.fetchResultAfterChanges
            self.photos = []
            self.fetchResult?.enumerateObjects { object, count, stop in
                self.photos.append(object)
            }
            print("after did change: \(self.photos.count)")
            self.collectionView.reloadData()
//            if changes.hasIncrementalChanges {
//
//                self.collectionView?.performBatchUpdates({
//                    if let removed = changes.removedIndexes, removed.count > 0 {
//                        removed.forEach { i in
//                            self.photos.remove(at: i)
//                        }
//
//                        self.collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section:0) })
//                    }
//                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
//                        self.collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
//                    }
//                    if let changed = changes.changedIndexes, changed.count > 0 {
//                        self.collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
//                    }
//                    changes.enumerateMoves { fromIndex, toIndex in
//                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                to: IndexPath(item: toIndex, section: 0))
//                    }
//                })
//            }
        }
        

    }
}


//extension SelectedPhotosViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        for result in results {
//            let provider = result.itemProvider
//
//            if provider.canLoadObject(ofClass: UIImage.self) {
//                provider.loadObject(ofClass: UIImage.self) { (image, error) in
//                    // save or display the image, if we got one
//                    if let image = image as? UIImage {
//                        DispatchQueue.main.async {
//                            self.photos.append(image)
//                            //print(image)
//                            self.collectionView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func getPhoto() {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 50
//        config.filter = .images
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//
//}

