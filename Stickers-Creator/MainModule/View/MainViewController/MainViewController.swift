//
//  ViewController.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import UIKit
import Foundation
import PhotosUI

enum BottomButtonImageNames: String {
    case Pencil = "pencil.circle"
    case Eraser = "scissors.circle"
    case Ruler = "circle.bottomhalf.filled"
    case Eye = "eye.circle"
    case Folder = "folder.circle"
    
    static let allValues = [Pencil, Eraser, Ruler, Eye, Folder]
    static var disabledValues = [true, false, false, false, false]
}

class MainViewController: UIViewController {
    var presenter: MainPresenterInputProtocol?
    
    var drawToolsSettingsDelegate: DrawToolsSettingsDelegate?
    
    var workspaceScrollView = UIScrollView()
    var textVC = UIView()
    var bottomButtonsStackView = UIStackView()
    var brushSizeSlider = UISlider()
    var workspaceImageView: MaskImageBinder?
    var brushSizeSliderValue: Float = 39.6
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        configureNavigationView()
        
        showEmptyScrollViewNotice()
        setUpBottomButtons()
    }
}

// MARK: - Bottom tools
extension MainViewController {
    func setUpBottomButtons() {
        let buttons = setUpButtons()
        bottomButtonsStackView = UIStackView(arrangedSubviews: buttons)

        for (disabledButtonIndex, disabledButtonValue) in BottomButtonImageNames.disabledValues.enumerated() where disabledButtonValue == true {
            buttons[disabledButtonIndex].tintColor = .gray
        }
        
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .equalSpacing
        view.addSubview(bottomButtonsStackView)
        
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomButtonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            bottomButtonsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonsStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        setupSlider()
    }

    func setUpButtons() -> [UIButton] {
        var buttons = [UIButton]()
        for buttonImageName in BottomButtonImageNames.allValues {
            let button = configurateButton(imageName: buttonImageName)
            buttons.append(button)
        }
        return buttons
    }

    
    // FIXME: - add targets
    func configurateButton(imageName: BottomButtonImageNames) -> UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        let image = UIImage(systemName: imageName.rawValue, withConfiguration: imageConfig)
        let button = UIButton()
        
        switch imageName {
        case .Pencil:
            button.addTarget(self, action: #selector(setPencilTool), for: .touchUpInside)
        case .Eraser:
            button.addTarget(self, action: #selector(setEraserTool), for: .touchUpInside)
        case .Ruler:
            button.addTarget(self, action: #selector(setHalfFilledTool), for: .touchUpInside)
        case .Eye:
            button.addTarget(self, action: #selector(showChanges), for: .touchUpInside)
        case .Folder:
            button.addTarget(self, action: #selector(showReadyStickers), for: .touchUpInside)
        }
        
        button.setImage(image, for: .normal)
        return button
    }
    
    @objc func setPencilTool() {
        drawToolsSettingsDelegate?.setTool(.Pencil)
        guard let disableIndex = BottomButtonImageNames.allValues.firstIndex(of: .Pencil) else { return }
        guard let eraserIndex = BottomButtonImageNames.allValues.firstIndex(of: .Eraser) else { return }
        BottomButtonImageNames.disabledValues[disableIndex] = true
        BottomButtonImageNames.disabledValues[eraserIndex] = false
        
        setUpBottomButtons()
    }
    
    @objc func setEraserTool() {
        drawToolsSettingsDelegate?.setTool(.Eraser)
        guard let disableIndex = BottomButtonImageNames.allValues.firstIndex(of: .Pencil) else { return }
        guard let eraserIndex = BottomButtonImageNames.allValues.firstIndex(of: .Eraser) else { return }
        BottomButtonImageNames.disabledValues[disableIndex] = false
        BottomButtonImageNames.disabledValues[eraserIndex] = true
        
        setUpBottomButtons()
    }
    
    @objc func setHalfFilledTool() {
        drawToolsSettingsDelegate?.setTool(.Ruler)
        guard let rulerIndex = BottomButtonImageNames.allValues.firstIndex(of: .Ruler) else { return }
        BottomButtonImageNames.disabledValues[rulerIndex] = !BottomButtonImageNames.disabledValues[rulerIndex]
        
        setUpBottomButtons()
    }
    
    @objc func showChanges() {
        
    }
    
    @objc func showReadyStickers() {
        
    }
    
    
    func setupSlider() {
        brushSizeSlider.minimumValue = 5.0
        brushSizeSlider.maximumValue = 75.0
        brushSizeSlider.value = brushSizeSliderValue

        brushSizeSlider.addTarget(self, action: #selector(changeBrushSize), for: .valueChanged)
        
        self.view.addSubview(brushSizeSlider)
        brushSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            brushSizeSlider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            brushSizeSlider.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            brushSizeSlider.heightAnchor.constraint(equalToConstant: 30),
            brushSizeSlider.bottomAnchor.constraint(equalTo: bottomButtonsStackView.topAnchor, constant: -15)
        ])
    }
    
    @objc func changeBrushSize() {
        brushSizeSliderValue = brushSizeSlider.value
        drawToolsSettingsDelegate?.setLineWidth(CGFloat(brushSizeSlider.value))
    }
}

