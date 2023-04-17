//
//  OptionalView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

protocol OptionalView: View {
    associatedtype PrimaryView: View
    associatedtype OptionalView: View
    
    var isPrimaryView: Bool { get }
    
    var primaryView: PrimaryView { get }
    
    var optionalView: OptionalView { get }
}

extension OptionalView {
    @ViewBuilder
    var body: some View {
        if isPrimaryView {
            self.primaryView
        } else {
            self.optionalView
        }
    }
}
