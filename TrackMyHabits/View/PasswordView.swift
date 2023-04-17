//
//  PasswordView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct PasswordView : View {
    @EnvironmentObject var passwordHelper: PasswordHelper
    @State private var showPassword: Bool = true
    
    var body: some View {
        if self.passwordHelper.level != .none {
            SecureLevelView(level: self.passwordHelper.level)
        }
        ToggleSecurefieldView(text: $passwordHelper.password)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(UIColor.opaqueSeparator), lineWidth: 2)
        }
        
    }
}
