//
//  BusinessInformations.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI

struct BusinessInformations: View {
    
    @State private var showEdit=false
    @StateObject var businessInfo=BusinessInformationsViewModel()
    
    var body: some View {
        VStack{
            HStack{
                 Spacer()
                 Button(action: {
                     showEdit.toggle()
                 }) {
                     Text("Düzenle")
                 }
             }
            Text("İletişim Bilgileri")
                .font(.title2)
                .fontWeight(.medium)
                VStack{
                    HStack{
                        Image(systemName: "map.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(businessInfo.address)
                    }
                    HStack{
                        Image(systemName: "location")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.green)
                            .background(Color.white)
                            .clipShape(Circle())
                        
                        Button(action: {
                            
                        }) {
                            Text("Yol tarifi al")
                                .foregroundColor(Color.white)
                        }
                        
                    }.padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.075)
                        .background(Color.blue)
                    
                    HStack{
                        Image(systemName: "phone")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.green)
                            .background(Color.white)
                            .clipShape(Circle())
                            
                        Button(action: {
                            
                        }) {
                            Text(businessInfo.phoneNumber)
                                .foregroundColor(Color.white)
                        }
                    }.padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.075)
                        .background(Color.green)

                }
        }
        .onAppear{
            businessInfo.getInfos()
        }
        .fullScreenCover(isPresented: $showEdit) { () -> EditBusinessInformations in
            return EditBusinessInformations()
        }
    }
}

struct BusinessInformations_Previews: PreviewProvider {
    static var previews: some View {
        BusinessInformations()
    }
}


//edit view

struct EditBusinessInformations: View {
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                EditAddressInformations()
                EditLocation()
                EditWorkingHour()
            }
        }
    }
}

struct EditAddressInformations: View {
    
    @State private var show=false

    @StateObject var businessInfo=BusinessInformationsViewModel()
    
    var body: some View {
        VStack{
            Spacer()
            CustomDismissButton(show: $show)
            Text("İletişim Bilgileri")
                .font(.title)
                .fontWeight(.medium)
            Group {
                TextField("telefon", text: $businessInfo.phoneNumber)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                TextField("mahalle", text: $businessInfo.village)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                TextField("cadde,sokak,no", text: $businessInfo.street)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                HStack{
                    TextField("ilçe", text: $businessInfo.town)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                    TextField("İl", text: $businessInfo.city)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
            }
            .background(Color.white)
            Button(action: {
                businessInfo.updateInfo()
            }) {
                Text("Düzenle")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(25)
            }
        }
        .onAppear{
            businessInfo.getInfos()
        }
        .fullScreenCover(isPresented: $show) { () -> BusinessAccountView in
            return BusinessAccountView()
        }
    }
}

struct EditLocation: View {
    var body: some View {
        VStack{
            Text("Navigasyon için sahanın konumunu ekleyin.")
                .font(.headline)
                .foregroundColor(Color.white)
                MapView()
                .frame(height:UIScreen.main.bounds.height * 0.35)
        }
    }
}

struct EditMenu: View {
    var body: some View {
        VStack{
            
        }
    }
}

struct EditWorkingHour: View {
    
    @State private var openingTime=""
    @State private var closingTime=""
    
    var body: some View {
        VStack {
            Text("Çalışma Saatleri")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color("myGreen"))
            HStack{
                TextField("Açılış saati", text: $openingTime)
                    .padding()
                    .border(Color.black, width: 2)
                TextField("Kapanış saati", text: $closingTime)
                    .padding()
                    .border(Color.black, width: 2)
            }
            Button(action: {
                //action
                
            })
            {
                Text("Onayla")
                    .padding()
                    .frame(width: 250.0, height: 50.0)
                    .background(Color("myGreen"))
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
            }
        }.frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.30).background(Color.white)
            .cornerRadius(25)
    }
}
