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
    @State private var screen=""
    
    let currentUser=Auth.auth().currentUser
    let firebaseDatabase=Firestore.firestore()
    
    var body: some View {
        VStack{
            if currentUser != nil {
                if users.userIDArray.contains(currentUser!.uid) {
                    CustomerHomeView()
                } else if businesses.businessIDArray.contains(currentUser!.uid) {
                    BusinessHomeView()
                }
            } else {
                HomeView()
            }
        }.onAppear{
            users.users()
            print(users.userIDArray)
            businesses.businesses()
            print(businesses.businessIDArray)
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
