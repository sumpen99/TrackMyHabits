//
//  PhotoGalleryPermissionHandler.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-23.
//

import SwiftUI
import Photos
class PhotoGalleryPermissionHandler : ObservableObject {
    @Published var authorizationStatus:PHAuthorizationStatus = .notDetermined
    
    func checkPermission(){
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.authorizationStatus = status
            }
        })
    }
}
