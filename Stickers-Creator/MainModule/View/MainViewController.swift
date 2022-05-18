//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    var presenter: MainPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(testPush), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.leftBarButtonItem = infoBarButtonItem
        
        self.title = "One"
    }

    @objc func testPush() {
        presenter?.tapOnInfoButton()
    }
}

extension MainViewController: MainPresenterOutputProtocol {
    
}
