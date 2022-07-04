//
//  ChangesResultPresenter.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 23.06.2022.
//

import Foundation
import UIKit

class ResultOfChangesPresenter: ResultOfChangesPresenterInputProtocol {
    weak var view: ResultOfChangesPresenterOutputProtocol?
    private var router: RouterProtocol?
    private var model: MainModel?
    
    required init(view: ResultOfChangesPresenterOutputProtocol, model: MainModel, router: RouterProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func getImage() -> UIImage? {
        return model?.photo
    }
    
    func getMask() -> UIImage? {
        return model?.mask
    }
    
//    func saveImage(_ image: UIImage) -> Bool {
//        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
//            return false
//        }
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//            return false
//        }
//        do {
//            try data.write(to: directory.appendingPathComponent("fileName.png")!)
//            return true
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
    
    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }

        guard let documentsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .allDomainsMask).first else { return }

        let fileName = "testFileName.png"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        print(fileURL, " - fileURL")

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
}
