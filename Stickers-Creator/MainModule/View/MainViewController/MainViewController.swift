//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    var presenter: MainPresenterInputProtocol?
    
    // UIScrollView
    var workspaceScrollView = UIScrollView()
    var workspaceImageView: MaskImageBinder?
    var brushSizeSliderValue: Float = 39.6
    var textVC = UIView()
    
    // setUpButtonsTools()
    var bottomButtonsStackView = UIStackView()
    var brushSizeSlider = UISlider()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
        showEmptyScrollViewNotice()
        setUpBottomTools()
    }
}

