//
//  LaunchScreenView.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.07.2022.
//

import SwiftUI
import Firebase

struct LaunchScreenView: View {
    
    @StateObject private var users=UserInformationsViewModel()
    @StateObject private var businesses=BusinessInformationsViewModel()
    
    let currentUser=Auth.auth().currentUser
    let firebaseDatabase=Firestore.firestore()
    
    var body: some View {
        if currentUser != nil {
            VStack{
                if users.userIDArray.contains(currentUser!.uid) {
                    CustomerHomeView()
                } else if businesses.businessIDArray.contains(currentUser!.uid) {
                    if businesses.city == "" {
                        BusinessLocationInfoView()
                    } else {
                        BusinessHomeView()
                    }
                }
            }.onAppear{
                //incele hata çıkabilir
                users.users()
                businesses.businesses()
                businesses.getInfos()
            }
        } else {
            HomeView()
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
