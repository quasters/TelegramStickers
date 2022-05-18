//
//  Presenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 17.05.2022.
//

import Foundation
import UIKit

protocol InfoPresenterProtocol {
    func followTheLink(username: String)
}

class InfoPresenter: InfoPresenterProtocol {
    var router: RouterProtocol?
    init(router: RouterProtocol){
        self.router = router
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
