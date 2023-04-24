//
//  HabitView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-20.
//

import SwiftUI
struct HabitView: View{
    @EnvironmentObject var firebaseHandler: FirebaseHandler
    @EnvironmentObject var userModel: UserModel
    var user:User?
    var body: some View {
        NavigationStack {
            List {
                Section(header:HeaderSubHeaderView(header:"Status",subHeader: Date.now.dayDateMonth())){
                    StatusCardView(habits: 3, habitsDone: 1, viewMoveTo: AnyView(Text("Hepp")))
                }
                Section(header: HStack{
                    Text("Vanor").sectionHeader()
                    Spacer()
                    NavigationLink(destination: Text("aaa")) {
                        Label("", systemImage: "plus").sectionHeader()
                    }
                }){
                    ForEach(0..<5, id: \.self){ _ in
                        HabitCardView()
                    }
                }
                NavigationButton(label:"Redigera min dag",
                                 viewMoveTo: AnyView(Text("aaa")))
               
           }
            .modifier(NavigationViewModifier(title: "Översikt"))
        }
        .onAppear(perform:{
            firebaseHandler.manager.getUser(email:firebaseHandler.getUserEmail()){ user in
                self.userModel.user = user
                USER_PROFILE_PIC_PATH = user.email
            }
        })
    }
}
