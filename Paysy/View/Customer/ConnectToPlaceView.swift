//
//  ConnectToPlaceView.swift
//  Paysy
//
//  Created by Anıl Demirci on 10.05.2022.
//

import SwiftUI

struct ConnectToPlaceView: View {
    @State var show=false
    @State private var selected="home"

    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button(action: {
                        selected="home"
                    }) {
                        Image(systemName: "house.fill")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="home" ? Color("logoColor") : Color.black.opacity(0.4))
                    }
                    Button(action: {
                        selected="menu"
                    }) {
                        Image(systemName: "menucard.fill")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="menu" ? Color("logoColor") : Color.black.opacity(0.4))
                    }
                    Button(action: {
                        selected="orders"
                    }) {
                        Image(systemName: "creditcard.circle.fill")
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.075)
                            .foregroundColor(selected=="orders" ? Color("logoColor") : Color.black.opacity(0.4))
                    }
                }
                if selected == "home" {
                    RequestConfirmed()
                } else if selected == "orders" {
                    OrdersView()
                } else if selected == "menu" {
                    MenuView()
                }
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
    
    @StateObject private var userInfo=UserInformationsViewModel()
    @StateObject private var connectToPlaceViewModel=ConnectToPlaceViewModel()
    @StateObject var timerManager = TimerManager()
    
    @State var people=["Ali","Ahmet","Anıl","Funda"]
    
    var body: some View {
            VStack{
                Text("Hoş geldin \(userInfo.firstName)")
                    .font(.title)
                Text("Masa ID: \(connectToPlaceViewModel.tableID)")
                Text("Masa Durumu: \(connectToPlaceViewModel.status)")
                //Text("\(timerManager.hour) saat \(timerManager.min) dakikadır masadasınız")
                Group{
                    Text("Masa şifreniz : abc123")
                    Text("Toplam Hesap : 500₺")
                    Text("Sizin hesabınız : 100₺")
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.05)
                .background(Color("logoColor"))
                .foregroundColor(.white)
                .font(.headline)
                List{
                    Section(header: Text("Masanızdaki kişiler: 4").foregroundColor((Color("logoColor")))){
                        ForEach(people,id:\.self) { i in
                            HStack{
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                    Text(i)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text(i)
                                        .font(.footnote)
                                        .fontWeight(.thin)
                                    Text(i)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                            }
                        }
                    }
                }.listStyle(.plain)
                Spacer()
                Button(action: {
                    timerManager.start()
                }) {
                    Text("Sipariş Ver")
                }
                Button(action: {
                    
                }) {
                    Text("Öde")
                }
            }
            .onAppear{
                userInfo.getInfos()
                
            }
    }
}

struct MenuView: View {
    //mekan ismini düzelt
    @StateObject private var menuViewModel=MenuViewModel()
    @State var selectedPlaceName="DorockXL"
    
    var body: some View {
        VStack{
            List{
                Section(header: Text("Menüler")){
                    ForEach(menuViewModel.categories,id:\.self){ i in
                        NavigationLink(destination: SelectedMenuForUserView(placeName: selectedPlaceName, menuName: i)) {
                            HStack(spacing:10){
                                Image(systemName: "menucard.fill")
                                Text(i)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
            }.listStyle(.plain)
        }
        .onAppear{
            menuViewModel.getMenu(placeName: "DorockXL")
        }
    }
}

struct SelectedMenuForUserView: View{
    
    @StateObject private var menuViewModel=MenuViewModel()
    @State var placeName=""
    @State var menuName=""
    @State private var selectedSubMenu=""
    @State var count=0
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(menuViewModel.subCategories,id:\.self) { i in
                        Button(action: {
                            selectedSubMenu=i
                            menuViewModel.getItem(placeName: placeName)
                        }) {
                            Text(i)
                                .padding()
                                .foregroundColor(selectedSubMenu==i ? Color.white : Color.black)
                                .frame(height: 50)
                                .background(selectedSubMenu==i ? Color("logoColor") : Color.white)
                                .cornerRadius(10)
                        }
                    }
                }.padding()
            }
            List{
                Section{
                    ForEach(menuViewModel.allItems) { item in
                        if item.SubMenuType == selectedSubMenu{
                            HStack() {
                                Image("antrikot")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(20)
                                Spacer()
                                VStack(spacing:20){
                                    Text(item.itemName)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text(item.statement)
                                        .font(.footnote)
                                        .fontWeight(.thin)
                                    Text(item.price)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                                Button(action: {
                                    count+=1
                                    print(item.itemName)
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color.green)
                                }
                            }
                        }
                    }
                }
            }.listStyle(.plain)
        }
        .navigationTitle(menuName).navigationBarTitleDisplayMode(.inline)
        .onAppear{
            menuViewModel.getSubMenu(placeName: placeName, menuName: menuName)
            menuViewModel.getItem(placeName: placeName)
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


