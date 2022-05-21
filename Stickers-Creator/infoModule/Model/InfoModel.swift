//
//  InfoModel.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 20.05.2022.
//

import Foundation

struct InfoModel {
    var groupSections: [String]
    var itemRows: [[String]]
    
    init() {
        groupSections = ["Developer", "Suggestions and help", "Donate"]
        itemRows = [["cybshot"], ["helpchat0", "helpchat1"], ["donatechat0"]]
    }
}
