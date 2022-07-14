//
//  MainPresenterTest.swift
//  Stickers-CreatorTests
//
//  Created by Наиль Буркеев on 13.07.2022.
//

import XCTest
@testable import Stickers_Creator
import Photos

final class MockView: MainViewPresenterOutputProtocol {
    var alertMessage: String?
    var alertMessageToSettings: String?
    var imageToWorkspace: UIImage?
    var isShowedActionSheet: Bool?
    var isOpenedGallery: Bool?
    var isOpenedCamera: Bool?
    var isCameraAccessed: Bool?
    var isLibraryAccessed: Bool?
    
    func showActionSheet() {
        isShowedActionSheet = true
    }
    
    func checkAccessToCamera() {
        isCameraAccessed = true
    }
    
    func checkAccessToLibrary() {
        isLibraryAccessed = true
    }
    
    func showWarningAlert(message: String) {
        alertMessage = message
    }
    
    func showWarningAlertToApplicationSettings(message: String) {
        alertMessageToSettings = message
    }
    
    func openGallery() {
        isOpenedGallery = true
    }
    
    func openCamera() {
        isOpenedCamera = true
    }
    
    func loadImageToWorkspace(image: UIImage) {
        imageToWorkspace = image
    }
    
    func reloadToolButtons() {
        
    }
}

final class MockStickerSenderDelegate: MainPresenterStickerSenderDelegate {
    var image = UIImage()
    func getImageMask() -> UIImage? {
        return image
    }
}

final class MockAccessManager: AccessManagerProtocol {
    func readCameraAccessPermission(complition: @escaping (Bool) -> Void) {
        complition(true)
    }
    
    func readPhotoLibraryAccessPemission(complition: @escaping (PHAuthorizationStatus) -> Void) {
        complition(PHAuthorizationStatus.authorized)
    }
}

final class MainPresenterTest: XCTestCase {
    var router: RouterProtocol!
    var accessManager: AccessManagerProtocol!
    var view: MockView!
    var presenter: MainPresenter!
    var stickerSenderDelegate: MockStickerSenderDelegate!
    var imageModel: MainModel!
    var lineModel: LineModel!

    override func setUpWithError() throws {
        let navController = UINavigationController()
        let assembly = AsselderBuilder()
        router = Router(navigationController: navController, assemblyBuilder: assembly)
        
        accessManager = MockAccessManager()
        view = MockView()
        imageModel = MainModel()
        stickerSenderDelegate = MockStickerSenderDelegate()
        presenter = MainPresenter(view: view, router: router, accessManager: accessManager, mainModel: imageModel)
        presenter.setStickerSenderDelegate(stickerSenderDelegate)
    }

    override func tearDownWithError() throws {
        router = nil
        view = nil
        presenter = nil
        accessManager = nil
    }
    
    func testGetCameraAccessPermissionIsAccessed() {
        var status: Bool?
        let expectation = self.expectation(description: "Waiting Camera request")
        presenter.getCameraAccessPermission { isAccessed in
            status = isAccessed
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30)
        XCTAssertEqual(status, true, "It have to be true")
    }
    
    func testGetPhotoLibraryAccessPermissionIsAuthorized() {
        var authorizationStatus: PHAuthorizationStatus?
        let expectation = self.expectation(description: "Waiting Photo Library request")
        presenter.getPhotoLibraryAccessPermission { status in
            authorizationStatus = status
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30)
        XCTAssertEqual(authorizationStatus, .authorized, "It have to be .authorized")
    }

    func testCallWarningAlertWithoutGoingToSettings() {
        presenter.callWarningAlert(message: "Baz", goTo: false)
        XCTAssertEqual(view.alertMessage, "Baz")
    }
    
    func testCallWarningAlertWithGoingToSettings() {
        presenter.callWarningAlert(message: "Bar", goTo: true)
        XCTAssertEqual(view.alertMessageToSettings, "Bar")
    }

    func testCallCameraIsOpened() {
        presenter.callCamera()
        XCTAssertEqual(view.isOpenedCamera, true)
    }
    
    func testCallGalleryIsOpened() {
        presenter.callGallery()
        XCTAssertEqual(view.isOpenedGallery, true)
    }
    
    func testTapOnCameraButton() {
        presenter.tapOnCameraButton()
        XCTAssertEqual(view.isShowedActionSheet, true)
    }
    
    func testCheckCameraAccessPermission() {
        presenter.checkCameraAccessPermission()
        XCTAssertEqual(view.isCameraAccessed, true)
    }
    
    func testCheckLibraryAccessPermission() {
        presenter.checkLibraryAccessPermission()
        XCTAssertEqual(view.isLibraryAccessed, true)
    }
}
