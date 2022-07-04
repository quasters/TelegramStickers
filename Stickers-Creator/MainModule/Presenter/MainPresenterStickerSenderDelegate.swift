//
//  MainPresenterStickerSenderDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 24.06.2022.
//

import Foundation
import UIKit

protocol MainPresenterStickerSenderDelegate: AnyObject {
    func getImageMask() -> UIImage?
}
