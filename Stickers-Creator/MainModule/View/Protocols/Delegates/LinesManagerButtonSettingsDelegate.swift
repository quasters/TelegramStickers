//
//  LinesManagerButtonSettingsDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 21.06.2022.
//

import Foundation

protocol LinesManagerButtonSettingsDelegate: AnyObject {
    func reloadActivityStatus(clearStatus: Bool, backStatus: Bool, forwardStatus: Bool)
}
