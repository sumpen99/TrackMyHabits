//
//  ProfileView.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-19.
//

import SwiftUI
import Photos

struct ProfileView: View{
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var firebaseAuth: FirebaseAuth
    @State var isShowPicker: Bool = false
    @State var image: Image? = Image(systemName:"photo.fill")
    @State private var isPrivacyResult = false
    @State var islogoutResult: Bool = false
    @State var animateOpacity: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                UserImage(profilePicture:$image,
                          isShowPicker:$isShowPicker,
                          isPrivacyResult: $isPrivacyResult)
                Section(header: Text("Personuppgifter")) {
                    Text(firestoreViewModel.user?.name ?? "").foregroundColor(.gray)
                    Text(firestoreViewModel.user?.email ?? "").foregroundColor(.gray)
                }
                Section(header: Text("Logga ut")) {
                    Button("Logga ut") {
                        islogoutResult.toggle()
                    }
                    
                }
            }
            .opacity(animateOpacity ? 0.0 : 1.0)
            .sheet(isPresented: $isShowPicker) {
                ImagePicker(image: self.$image,sourceType: .photoLibrary)
            }
            .alert(isPresented: $isPrivacyResult, content: {
                onPrivacyAlert(actionPrimary: openPrivacySettings,
                               actionSecondary: {})
                 
            })
            .modifier(NavigationViewModifier(title: firestoreViewModel.user?.name ?? ""))
        }
        .onAppear(){
            FileHandler.getSavedImage(USER_PROFILE_PIC_PATH){ result in
                if result.finishedWithoutError{
                    guard let uimage = result.value as? UIImage else { return }
                    self.image = Image(uiImage: uimage)
                }
                
            }
        }
        .alert(isPresented: $islogoutResult, content: {
            onAlertWithOkAction(title: "Verifiera utloggning", message: ""){
                releaseData()
            }
             
        })
    }
    
    func openPrivacySettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(url) else {
                    assertionFailure("Not able to open App privacy settings")
                    return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func releaseData(){
        firestoreViewModel.releaseData()
        animateViewOut()
    }
    
    func animateViewOut(){
        withAnimation(Animation.spring()) {
            animateOpacity.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            image = nil
            firebaseAuth.signOut()
        }
    }
     
}

struct UserImage: View{
    @Binding var profilePicture:Image?
    @Binding var isShowPicker:Bool
    @Binding var isPrivacyResult:Bool
    @StateObject var photoGalleryPermissionHandler = PhotoGalleryPermissionHandler()
    
    var body: some View{
        HStack(alignment: .center){
            Spacer()
            profilePicture?
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .foregroundColor(.darkCardBackground)
                .onTapGesture {
                    photoGalleryPermissionHandler.checkPermission()
                    switch photoGalleryPermissionHandler.authorizationStatus {
                      case .notDetermined:
                            photoGalleryPermissionHandler.requestPermission()
                      case .denied, .restricted:
                            activateAccessDeniedAlert()
                            isPrivacyResult.toggle()
                      case .authorized:
                            isShowPicker.toggle()
                     case .limited:
                            activateNotImplementedAlert()
                            isPrivacyResult.toggle()
                      @unknown default:
                         fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
                    }
                }
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
    
    func activateNotImplementedAlert(){
        ALERT_PRIVACY_TITLE = "Sorry"
        ALERT_PRIVACY_MESSAGE = "We have not impelemented choose pictures yet. If you still want to choose images, please go to settings to set permission"
    }
    
    func activateAccessDeniedAlert(){
        ALERT_PRIVACY_TITLE = "Missing Permission"
        ALERT_PRIVACY_MESSAGE = "Please go to settings to set permission"
    }
}
