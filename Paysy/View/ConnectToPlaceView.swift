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
    var body: some View {
        VStack{
            Text("Menu")
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


