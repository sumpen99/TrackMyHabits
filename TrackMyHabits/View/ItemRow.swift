//
//  ItemRow.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-21.
//
import SwiftUI
struct ItemRow: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(self.text).foregroundColor(.gray).font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
    }
}
