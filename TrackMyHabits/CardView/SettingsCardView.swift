//
//  SettingsCardView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-23.
//
import SwiftUI
struct SettingsCardView: View {
    var title: String = ""
    var subTitle: String = ""
    var imageName: String = ""
    
    var body: some View {
        NavigationLink(destination: Text("aaa")){
            HStack(alignment: .center) {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
                    .accessibility(hidden: true)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .accessibility(addTraits: .isHeader)
                    
                    Text(subTitle)
                        .font(.body)
                        .foregroundColor(.blue)
                        .opacity(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
}
