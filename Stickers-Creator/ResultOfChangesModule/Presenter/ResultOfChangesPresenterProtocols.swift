//
//  ChangesResultPresenterProtocol.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 22.06.2022.
//

import Foundation
import UIKit

protocol ResultOfChangesPresenterInputProtocol: AnyObject {
    func getImage() -> UIImage?
    func getMask() -> UIImage?
    func tappedDoneButton()
}


protocol ResultOfChangesPresenterOutputProtocol: AnyObject {
    func saveImage()
}
