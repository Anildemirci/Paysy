//
//  ConnectToPlaceView.swift
//  Paysy
//
//  Created by Anıl Demirci on 10.05.2022.
//

import SwiftUI

struct ConnectToPlaceView: View {
    @State var show=false
    @State private var selected="menu"
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button(action: {
                        selected="home"
                    }) {
                        Image(systemName: "house.fill")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="home" ? Color.black : Color.black.opacity(0.4))
                    }
                    Button(action: {
                        selected="menu"
                    }) {
                        Image(systemName: "menucard")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="menu" ? Color.black : Color.black.opacity(0.4))
                    }
                    Button(action: {
                        selected="orders"
                    }) {
                        Image(systemName: "creditcard.circle")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="orders" ? Color.black : Color.black.opacity(0.4))
                    }
                }
                .padding()
                Spacer()
                if selected == "home" {
                    RequestConfirmed()
                } else if selected == "orders" {
                    OrdersView()
                } else if selected == "menu" {
                    MenuView()
                }
                Spacer()
            }.navigationTitle("Bausta Masa 5").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConnectToPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectToPlaceView()
    }
}

struct RequestConfirmed: View{
    var body: some View {
            VStack{
                Text("Hoş geldin Anıl")
                    .font(.title)
                Spacer()
                Text("Masa şifreniz: abc123")
                Text("Toplam Hesap = 500₺")
                Text("Sizin hesabınız = 100₺")
                HStack{
                    Text("Masanızdaki kişiler: 4")
                    Button(action: {
                        
                    }) {
                        Image(systemName: "info.circle.fill")
                    }
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Text("Sipariş Ver")
                }
                Button(action: {
                    
                }) {
                    Text("Öde")
                }
            }
    }
}

struct MenuView: View {
    
    @State var show=false
    @State private var selected="food"
    
    var body: some View {
        VStack{
            if selected == "drink" {
                DrinkMenuView()
            } else if selected == "food" {
                FoodMenuView()
            }
            Spacer()
            HStack{
                Button(action: {
                    selected="drink"
                }) {
                    VStack{
                        Image(systemName: "menucard.fill")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="drink" ? Color.black : Color.black.opacity(0.4))
                        Text("İçecekler")
                    }
                }
                Button(action: {
                    selected="food"
                }) {
                    VStack{
                        Image(systemName: "menucard.fill")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="food" ? Color.black : Color.black.opacity(0.4))
                        Text("Yiyecekler")
                    }
                }
            }
            .padding()
            Spacer()
        }
    }
}

struct DrinkMenuView: View{
    
    var body: some View {
        VStack{
            List{
                Section(header: Text("Biralar")){
                    HStack{
                        Text("Efes 55₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Tuborg 50₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Heineken 75₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Carlsberg 60₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                }
                Section(header: Text("Şaraplar")){
                    HStack{
                        Text("Dlc 255₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Yakut 250₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Sarafin 275₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Anfora 230₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                }
            }
        }
    }
}

struct FoodMenuView: View{
    
    var body: some View {
        VStack{
            List{
                Section(header: Text("Kırmızı Etler")){
                    HStack{
                        Text("Pirzola 175₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Antrikot 150₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Steak 175₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Bonfile 140₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                }
                Section(header: Text("Beyaz Etler")){
                    HStack{
                        Text("Tavuk Pirzola 85₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Barbekü Soslu Tavuk 75₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Şinitzel 55₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                    HStack{
                        Text("Tavuk Kanat 70₺")
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(Color.blue)
                    }
                }
            }
        }
    }
}

struct OrdersView: View {
    var body: some View {
        VStack{
            List{
                Section(header: Text("Bekleyen Siparişler")) {
                    HStack{
                        Text("Pizza 75₺")
                        Spacer()
                        Image(systemName: "clear.fill")
                            .foregroundColor(Color.red)
                    }
                    HStack{
                        Text("Şarap 65₺")
                        Spacer()
                        Image(systemName: "clear.fill")
                            .foregroundColor(Color.red)
                    }
                }
                Section(header: Text("Gelen Siparişler")) {
                    Text("Bira x2 100₺")
                    Text("Kokteyl x1 110₺")
                }
            }.listStyle(.sidebar)
            Spacer()
            NavigationLink(destination: PayView()) {
                Text("Öde")
                    .padding()
            }
            Spacer(minLength: 10)
        }
    }
}

struct PayView: View{
    var body: some View {
        VStack{
            Text("Ödeme ekranı")
        }
    }
}


