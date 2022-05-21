//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

protocol InfoPresenterInputProtocol: AnyObject {
    func followTheLink(username: String)
    
    func getSectionLabel(section: Int) -> String
    func getRowLabel(section: Int, row: Int) -> String
    func getSectionsCount() -> Int
    func getRowCount(section: Int) -> Int
}

protocol InfoViewPresenterOutputProtocol: AnyObject {
    // nothing now
}

class InfoPresenter: InfoPresenterInputProtocol {
    weak var view: InfoViewPresenterOutputProtocol?
    var router: RouterProtocol?
    var infoModel: InfoModel
    init(view: InfoViewPresenterOutputProtocol, router: RouterProtocol, infoModel: InfoModel){
        self.router = router
        self.infoModel = infoModel
    }
    
    
    func getSectionLabel(section: Int) -> String {
        return infoModel.groupSections[section]
    }

    func getRowLabel(section: Int, row: Int) -> String {
        return infoModel.itemRows[section][row]
    }
    
    func getSectionsCount() -> Int {
        return infoModel.groupSections.count
    }
    
    func getRowCount(section: Int) -> Int {
        return infoModel.itemRows[section].count
    }
    

    func followTheLink(username: String) {
        let appURL = URL(string: "tg://resolve?domain=\(username)")!
        let webURL = URL(string: "https://t.me/\(username)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL)
            } else {
                UIApplication.shared.openURL(webURL)
            }
        }
    }
    
}
