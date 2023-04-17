//
//  PasswordStrengthView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

struct SecureLevelView : View {
    var level: PasswordLevel
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8).foregroundColor(self.getColors()[0]).frame(height: 10)
            RoundedRectangle(cornerRadius: 8).foregroundColor(self.getColors()[1]).frame(height: 10)
            RoundedRectangle(cornerRadius: 8).foregroundColor(self.getColors()[2]).frame(height: 10)
        }
    }

    func getColors() -> [Color] {
        switch self.level {
        case .none:
            return [.clear, .clear, .clear]
        case .weak:
            return [.red, .clear, .clear]
        case .ok:
            return [.clear, .orange, .clear]
        case .strong:
            return [.clear, .clear, .green]
        }
    }
}
