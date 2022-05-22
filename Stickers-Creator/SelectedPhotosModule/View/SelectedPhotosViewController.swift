//
//  SelectedPhotosViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import UIKit
import PhotosUI


class SelectedPhotosViewController: UIViewController {
    var presenter: SelectedPhotosPresenter?
    var photos = [UIImage]()
    var selectedCollection: UICollectionView?
    //var options: PHFetchOptions?
    //var assets: PHFetchResult<PHAsset>?
    
    override func  viewWillLayoutSubviews() {
//        let image = UIImageView()
//        image.image = UIImage(named: "tg-icon")
//        image.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        image.contentMode = .scaleToFill
//        image.center = view.center
//        view.addSubview(image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        createCollection()
        getPhoto()
        
    }

//    func createCollection() {
//        let collection = UICollectionView(frame: view.frame)
//        view.addSubview(collection)
//    }
    
    func configureNavigationBar() {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMainVC))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func backToMainVC() {
        presenter?.tapOnCloseButton(view: self)
    }
}





extension SelectedPhotosViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    // save or display the image, if we got one
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.photos.append(image)
                            self.selectedCollection?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        DispatchQueue.main.async { [unowned self] in
//            guard let assets = self.assets else { return }
//            if let photosChanges = changeInstance.changeDetails(for: assets) {
//                assets = photosChanges.changedObjects as PHFetchResult<PHAsset>
//            }
//        }
//    }
    
    func getPhoto() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 50
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
        
//        options = PHFetchOptions()
//        options?.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ] // SORTING
//        assets = PHAsset.fetchAssets(with: .image, options: options)
        
        
        
        
        //PHImageManager.default().requestImage(for: assets, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: <#T##(UIImage?, [AnyHashable : Any]?) -> Void#>)
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return smartAlbum.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        return cell
//    }
}

extension SelectedPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedCollection?.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! SelectedCell
        cell.setImage(image: photos[indexPath.row])
        return cell
    }
    
    
}

extension SelectedPhotosViewController: UICollectionViewDelegate {
    
}






extension SelectedPhotosViewController: SelectedPhotosViewPresenterOutputProtocol {
    
}



extension SelectedPhotosViewController {
    func createCollection() {
        self.selectedCollection = UICollectionView(frame: view.frame)
        configureCollection()
        view.addSubview(selectedCollection!)
    }
    
    private func configureCollection() {
        self.selectedCollection?.register(SelectedCell.self, forCellWithReuseIdentifier: "id")
        setTableDelegates()
    }
    
    private func setTableDelegates() {
        self.selectedCollection?.dataSource = self
        self.selectedCollection?.delegate = self
    }
}
