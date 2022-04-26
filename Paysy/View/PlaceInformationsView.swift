//
//  PlaceInformationsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct PlaceInformationsView: View {
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                Spacer()
                Contact()
                Spacer()
                Menu()
                Spacer()
                WorkingHours()
                Spacer()
            }
        }
        .padding()
        .background(Color("back"))
    }
}

struct PlaceInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInformationsView()
    }
}

struct Contact : View {
    var body: some View {
        
        Text("İletişim Bilgileri")
            .font(.title2)
            .fontWeight(.medium)
            VStack{
                HStack{
                    Image(systemName: "map.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Caferağa Mh Moda Cd. &, Damacı Sk. No:4, 34710 Kadıköy")
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
                        Text("0537 254 12 34")
                            .foregroundColor(Color.white)
                    }
                }.padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.075)
                    .background(Color.green)

            }
            .padding()
            .background(Color.white)
    }
}

struct Menu: View {
    var body: some View {
        VStack{
            Text("Menü")
                .font(.title2)
                .fontWeight(.medium)
            VStack{
                ScrollView(.horizontal,showsIndicators: false){
                    HStack(spacing:15){
                        Group {
                            Image("menu1")
                                .resizable()
                            Image("menu2")
                                .resizable()
                            Image("menu3")
                                .resizable()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                        
                    }.frame(height: UIScreen.main.bounds.height * 0.25)
                }
            }
        }
    }
}


struct WorkingHours: View {
    var body: some View {
        VStack{
            Text("Çalışma Saatleri")
                .font(.title2)
                .fontWeight(.medium)
            List{
                HStack{
                    Text("Pazartesi")
                    Spacer()
                    Text("12:00-02:00")
                }
                HStack{
                    Text("Salı")
                    Spacer()
                    Text("12:00-02:00")
                }
                HStack{
                    Text("Çarşamba")
                    Spacer()
                    Text("12:00-02:00")
                }
                HStack{
                    Text("Perşembe")
                    Spacer()
                    Text("12:00-02:00")
                }
                HStack{
                    Text("Cuma")
                    Spacer()
                    Text("12:00-03:00")
                }
                HStack{
                    Text("Cumartesi")
                    Spacer()
                    Text("12:00-03:00")
                }
                HStack{
                    Text("Pazar")
                    Spacer()
                    Text("12:00-02:00")
                }
            }.listStyle(.plain)
                .frame(height: UIScreen.main.bounds.height * 0.4)
        }
    }
}
