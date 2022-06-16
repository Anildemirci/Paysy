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
    
    init() {
        let NavBarAppearance = UINavigationBarAppearance()
        NavBarAppearance.configureWithOpaqueBackground()
        NavBarAppearance.backgroundColor = .purple
        NavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        NavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
        UINavigationBar.appearance().standardAppearance = NavBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = NavBarAppearance
        
        //let TabBarAppearance = UITabBar.appearance()
        //TabBarAppearance.barTintColor = .blue
        //TabBarAppearance.scrollEdgeAppearance = UITabBarAppearance()
        //TabBarAppearance.standardAppearance = UITabBarAppearance()
        //TabBarAppearance.isHidden=false
        }
    
    var body: some View {
            VStack(spacing: 25){
                    Image("paysy")
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.45)
                        .cornerRadius(20)
                        .padding()
                HStack{
                    Button(action: {
                        showCustomer.toggle()
                    }) {
                        Image("customer")
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.25)
                            .cornerRadius(20)
                            //.padding()
                    }
                    Button(action: {
                        showBusiness.toggle()
                    }) {
                        Image("business")
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.25)
                            .cornerRadius(20)
                            //.padding()
                    }
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 1)
            .padding()
            .background(Color("back"))
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showCustomer) { () -> CustomerHomeView in
            return CustomerHomeView()
        }
        .fullScreenCover(isPresented: $showBusiness) { () -> BusinessHomePage in
            return BusinessHomePage()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}





