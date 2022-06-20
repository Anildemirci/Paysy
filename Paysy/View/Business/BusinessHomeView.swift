//
//  BusinessHomeView.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI
import Firebase

struct BusinessHomeView: View {
    
    var currentUser=Auth.auth().currentUser
    @State var showSignIn=false
    @State var showLogin=false
    var body: some View {
        if currentUser != nil {
            BusinessAccountView()
        } else {
            VStack{
                Image("paysy_business")
                    .resizable()
                    .frame(width:UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45)
                    .cornerRadius(20)
                    .padding()
                Spacer()
                Button(action: {
                    showSignIn.toggle()
                }) {
                    Text("Üye Ol")
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.yellow)
                        .cornerRadius(20)
                }
                Button(action: {
                    showLogin.toggle()
                }) {
                    Text("Giriş Yap")
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.yellow)
                        .cornerRadius(20)
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $showSignIn) { () -> SignInForBusiness in
                SignInForBusiness()
            }
            .fullScreenCover(isPresented: $showLogin) { () -> LoginForBusiness in
                LoginForBusiness()
            }
        }
    }
}

struct BusinessHomeView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessHomeView()
    }
}
