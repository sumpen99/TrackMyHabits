//
//  TodaysTodoView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-30.
//

import SwiftUI

struct TodaysTodoView: View{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @Binding var userStatus: UserStatus
    @State var showSuccesAlert:Bool = false
    var body: some View{
        NavigationStack {
            ScrollView{
                VStack() {
                    ForEach(userStatus.habitsTodo,id:\.id){ todo in
                        RegisterDoneCardView(
                            docId:todo.id,
                            title:todo.title,
                        showSuccesAlert: $showSuccesAlert)
                    }
                    
                }
            }
            .listRowBackground(Color(hex: 0xFFFAFA,alpha: 0.1))
            
        }
        .alert("Vana registrerad som klar", isPresented: $showSuccesAlert) { Button("OK", role: .cancel) {}}
        .modifier(NavigationViewModifier(title: "Dagens Utmaningar"))
    }
}

struct RegisterDoneCardView: View {
    var docId: String
    var title: String
    var subTitle: String = "Vill du lägga till en kommentar från dagen?"
    @Binding var showSuccesAlert:Bool
    @State var isTextFieldShowing:Bool = false
    @State var userComment:String = ""
    @State var habitIsUpdated:Bool = false
    var body: some View {
        ZStack(alignment: .center){
            Color.lightBackground
            HStack(alignment: .center) {
                Image(systemName: habitIsUpdated ? "checkmark" : "questionmark")
                    .font(.largeTitle)
                    .foregroundColor(Color.cardColor)
                    .padding()
                    .accessibility(hidden: true)
                
                VStack(alignment: .leading,spacing: 10) {
                    Text(title)
                        .lineLimit(1)
                        .foregroundColor(Color.cardColor)
                        .frame(alignment: .leading)
                    Text(subTitle)
                        .font(.caption)
                        .foregroundColor(Color.cardColor)
                        .opacity(0.8)
                        .lineLimit(1)
                    if !habitIsUpdated{
                        HStack{
                            Toggle("Ja", isOn: $isTextFieldShowing.animation())
                                .foregroundColor(Color.cardColor)
                                .toggleStyle(ButtonToogle())
                                .frame(alignment: .leading)
                            Button("Nej, skicka in utan") {
                                updateHabitIsDone()
                            }
                            .foregroundColor(Color.cardColor)
                            .buttonStyle(.bordered)
                            .disabled(isTextFieldShowing)
                            .opacity(isTextFieldShowing ? 0.0 : 1.0)
                        }
                        if isTextFieldShowing {
                            Divider()
                            VStack(alignment: .leading,spacing: 10.0){
                                TextField("Min upplevelse", text: $userComment)
                                    .padding(10)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                HStack{
                                    Spacer()
                                    Button("Skicka in") {
                                        updateHabitIsDone()
                                    }
                                    .foregroundColor(Color.cardColor)
                                    .buttonStyle(.bordered)
                                }.padding([.trailing])
                            }
                            .padding([.top,.bottom])
                        }
                    }
                    
                }
                .padding([.trailing],30.0)
            }
        }
        .modifier(CardModifier(size: getSize() ))
        .padding()
    }
    
    func getSize()->CGFloat{
        if habitIsUpdated { return 120.0}
        return isTextFieldShowing ? 250.0 : 120.0
    }
    
    func updateHabitIsDone(){
        printAny("Update \(docId)")
        habitIsUpdated = true
        showSuccesAlert.toggle()
    }
    
}

struct CardGrayTrailing:View{
    var body:some View{
        Spacer()
        Rectangle()
             .fill(Color.gray)
             .frame(width:30)
    }
}

struct ButtonToogle: ToggleStyle {

    func makeBody(configuration: Self.Configuration) -> some View {

        return HStack() {
            Button(configuration.isOn ? "Avbryt" : "Ja") {
                configuration.isOn.toggle()
            }.buttonStyle(.bordered)
        }
    }
}

