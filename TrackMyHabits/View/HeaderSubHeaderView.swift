//
//  HeaderSubHeaderView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-23.
//

import SwiftUI

struct HeaderSubHeaderView: View{
    let header:String
    let subHeader:String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header).sectionHeader()
            Text(subHeader).fontWeight(.regular)
        }
    }
}
