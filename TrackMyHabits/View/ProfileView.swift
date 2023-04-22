//
//  ProfileView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

import SwiftUI
//https://www.hackingwithswift.com/forums/swiftui/background-color-of-a-list-make-it-clear-color/3379
struct ProfileView: View{
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("ONSDAG 19 APRIL")) {
                    Text("Översikt").bold().font(.largeTitle)
                        .listRowBackground(Color.green)
                }
                Section(header: Text("Your Info 1")) {
                    TextFieldsToTest()
                }
                Section(header: Text("Your Info 1")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 2")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 3")) {
                    TextFieldsToBeRemoved()
                }
                Section(header: Text("Your Info 1")) {
                    NavigationLink(destination: Text("aaa")) {
                    MenuInformationDetailView(title: "Changing behaviour", subTitle: "How to use the behavioural experiments feature", imageName: "questionmark.circle.fill")
                        //.background( NavigationLink("", destination: Text("The detail view")) )
                        
                    }
                }
                ZStack {
                  //Create a NavigationLink without the disclosure indicator
                  NavigationLink(destination: Text("Hello, World!")) {
                    EmptyView()
                  }

                  //Replicate the default cell
                  HStack {
                    Text("Custom UI")
                    Spacer()
                    Image(systemName: "chevron.right")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 7)
                      .foregroundColor(.red) //Apply color for arrow only
                  }
                  .foregroundColor(.purple) //Optional: Apply color on all inner elements
                }
            }
            .listRowBackground(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            //.background( appLinearGradient() )
            .background( APP_BACKGROUND_COLOR )
            
            .navigationBarTitle(Text("Fredrik Sundström"),displayMode: .automatic)
            
            /*.onAppear(perform: {
                        setNavigationAppearance()
                    })*/
        }
    }
    
}

struct MenuInformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "exclamationmark.circle.fill"
    
    var body: some View {
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

struct TextFieldsToBeRemoved: View{
    var body: some View{
        Text("$user.name")
            .removePredictiveSuggestions()
            .textContentType(.name)
        Text("$user.email")
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}

struct TextFieldsToTest: View{
    var body: some View{
        Text("Onsdag 19 April")
            .removePredictiveSuggestions()
            .textContentType(.name)
        Text("Översikt")
            .removePredictiveSuggestions()
            .textContentType(.emailAddress)
        
    }
}
