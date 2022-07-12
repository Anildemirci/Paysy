//
//  HomeView.swift
//  Paysy
//
//  Created by Anıl Demirci on 12.04.2022.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @State var showCustomer=false
    @State var showBusiness=false
    

    var body: some View {
            VStack(spacing: 25){
                    Image("Paysy_Logo")
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.55)
                        .cornerRadius(20)
                        .padding()
                HStack(spacing:12){
                    Button(action: {
                        showCustomer.toggle()
                    }) {
                        Image("customer2")
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.25)
                            .cornerRadius(20)
                            .shadow(color: Color("logoColor"), radius: 4)
                            //.padding()
                    }
                    
                    Button(action: {
                        showBusiness.toggle()
                    }) {
                        Image("business")
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.25)
                            .cornerRadius(20)
                            .shadow(color: Color("logoColor"), radius: 4)
                            //.padding()
                    }
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 1)
            .padding()
            //.background(Color("back"))
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showCustomer) { () -> CustomerHomeView in
            return CustomerHomeView()
        }
        .fullScreenCover(isPresented: $showBusiness) { () -> BusinessHomeView in
            return BusinessHomeView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}





