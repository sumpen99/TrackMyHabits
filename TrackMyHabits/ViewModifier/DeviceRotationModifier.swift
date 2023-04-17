//
//  DeviceRotationModifier.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier{
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
            content
                .onAppear()
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    action(UIDevice.current.orientation)
                }
        }
}
