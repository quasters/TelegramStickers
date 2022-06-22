//
//  setUpBottomTools().swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import Foundation
import UIKit

// MARK: - Bottom tools
extension MainViewController {
    func setUpBottomTools() {
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

    private func setUpButtons() -> [UIButton] {
        var buttons = [UIButton]()
        for buttonImageName in BottomButtonImageNames.allValues {
            let button = configurateButton(imageName: buttonImageName)
            buttons.append(button)
        }
        return buttons
    }

    private func configurateButton(imageName: BottomButtonImageNames) -> UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        let image = UIImage(systemName: imageName.rawValue, withConfiguration: imageConfig)
        let button = UIButton()
        
        switch imageName {
        case .Pencil:
            button.addTarget(self, action: #selector(setPencilTool), for: .touchUpInside)
        case .Eraser:
            button.addTarget(self, action: #selector(setEraserTool), for: .touchUpInside)
        case .Ruler:
            button.addTarget(self, action: #selector(setRulerTool), for: .touchUpInside)
        case .Eye:
            button.addTarget(self, action: #selector(showChanges), for: .touchUpInside)
        case .Folder:
            button.addTarget(self, action: #selector(showReadyStickers), for: .touchUpInside)
        }
        
        button.setImage(image, for: .normal)
        return button
    }
    
    @objc private func setPencilTool() {
        presenter?.tapOnToolButton(tool: .Pencil)
    }
    
    @objc private func setEraserTool() {
        presenter?.tapOnToolButton(tool: .Eraser)
    }
    
    @objc private func setRulerTool() {
        presenter?.tapOnToolButton(tool: .Ruler)
    }
    
    @objc private func showChanges() {
        presenter?.tapOnToolButton(tool: .Eye)
    }
    
    @objc private func showReadyStickers() {
        presenter?.tapOnToolButton(tool: .Folder)
    }
    
    
    private func setupSlider() {
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
    
    @objc private func changeBrushSize() {
        brushSizeSliderValue = brushSizeSlider.value
        presenter?.setLineWidth(CGFloat(brushSizeSlider.value))
    }
}

