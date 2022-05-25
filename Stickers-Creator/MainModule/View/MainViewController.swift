//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    var presenter: MainPresenterInputProtocol?
    var imageView = UIImageView()
    
    //var textLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
  
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        imageView.center = view.center
        imageView.contentMode = .scaleToFill
        
       
        //self.view.addSubview(imageView)
    }


}

extension MainViewController: MainViewPresenterOutputProtocol {
    func setImageView(image: UIImage) {
        let newImage = UIImageView()
        newImage.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        newImage.center = view.center
        newImage.contentMode = .scaleToFill
        newImage.image = image
        self.view.addSubview(newImage)
        //print(image.size)
        //print(imageView.image!.size)
    }
}



