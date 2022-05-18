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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabView()  // SetupNavigationView

//        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
//        imageView.center = view.center
//        imageView.contentMode = .scaleToFill

    }


}

extension MainViewController: MainPresenterOutputProtocol {
    
}



