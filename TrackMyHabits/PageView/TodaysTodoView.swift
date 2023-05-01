//
//  TodaysTodoView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-30.
//

import SwiftUI

struct TodaysTodoView: OptionalView{
    @Environment(\.dismiss) private var dismiss
    @Binding var userStatus: UserStatus
    @State var showSuccesAlert:Bool = false
    @State var showNoActiveHabits:Bool = false
    var isPrimaryView: Bool { !userStatus.habitsTodo.isEmpty }
    var primaryView: some View{
        NavigationStack {
            ScrollView{
                VStack() {
                    ForEach(userStatus.habitsTodo,id:\.id){ todo in
                        RegisterDoneCardView(
                            docId:todo.docId,
                            title: todo.title,
                            nextDate:todo.nextDate,
                            streak: todo.streak,
                            habitIsDone: todo.isDone,
                            showSuccesAlert: $showSuccesAlert)
                    }
                    
                }
            }
            .listRowBackground(Color(hex: 0xFFFAFA,alpha: 0.1))
        }
        .alert("Vana registrerad som klar", isPresented: $showSuccesAlert) { Button("OK", role: .cancel) {}}
        .modifier(NavigationViewModifier(title: "Dagens Utmaningar"))
    }
    
    var optionalView: some View {
        NavigationStack {
        }
        .alert("Inga vanor aktiva", isPresented: $showNoActiveHabits) { Button("OK", role: .cancel) {
            dismiss()
        }}
        .modifier(NavigationViewModifier(title: "Dagens Utmaningar"))
        .onAppear(){
            showNoActiveHabits.toggle()
        }
    }
}
