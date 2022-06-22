//
//  DrawToolsSettingsDelegate.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 21.06.2022.
//

import UIKit

protocol DrawToolsSettingsDelegate: AnyObject {
    func setLineWidth(_ width: CGFloat)
    func setTool(_ tool: BottomButtonImageNames)
}
