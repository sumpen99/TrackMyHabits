//
//  NavigationButton.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-22.
//

import SwiftUI

struct NavigationButton: View {
    var label:String
    var viewMoveTo: AnyView
    
    var body: some View {
        ZStack {
            NavigationLink(destination: viewMoveTo,
                        label: {}).opacity(0)

          HStack {
            Text(label)
            /*Image(systemName: "chevron.right")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 7)
              .foregroundColor(.red)*/ //Apply color for arrow only
          }
          .foregroundColor(.blue)
        }
        
    }
    
}
