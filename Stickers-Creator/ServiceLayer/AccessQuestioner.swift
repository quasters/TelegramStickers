//
//  AccessQuestioner.swift
//  Stickers-Creator
//
//  Created by Наиль Буркеев on 19.05.2022.
//

import Foundation
import Photos

protocol AccessManagerProtocol {
    func readCameraAccessPermission(complition: @escaping (Bool) -> Void)
    func readPhotoLibraryAccessPemission(complition: @escaping (PHAuthorizationStatus) -> Void)
}

class AccessManager: AccessManagerProtocol {
    // MARK: - Camera Access
    private func requestCameraAccessPermission(complition: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { response in
            complition(response)
        }
    }
    
    func readCameraAccessPermission(complition: @escaping (Bool) -> Void) {
        let response = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        if response {
            complition(response)
        } else {
            requestCameraAccessPermission { response in
                complition(response)
            }
        }
    }
    
    // MARK: - Photo Library Access
    private func requestPhotoLibraryAccessPemission(complition: @escaping (PHAuthorizationStatus) -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                complition(status)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                complition(status)
            }
        }
        
    }
    
    func readPhotoLibraryAccessPemission(complition: @escaping (PHAuthorizationStatus) -> Void) {
        var status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        
        switch status {
        case .notDetermined, .denied:
            requestPhotoLibraryAccessPemission { status in
                complition(status)
            }
        default:
            complition(status)
        }
        
    }
}
