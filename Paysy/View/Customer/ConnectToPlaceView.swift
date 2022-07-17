//
//  ConnectToPlaceView.swift
//  Paysy
//
//  Created by Anıl Demirci on 10.05.2022.
//

import SwiftUI
import Firebase

struct ConnectToPlaceView: View {
    @State private var show=false
    @State private var selected="home"
    @State var selectedPlace=""
    @State var tableID=""
    @StateObject private var connectToPlaceViewModel=GetConnectionInfoViewModel()
    @State var tableNum=""
    @State private var orderArray=[orderModel]()
    @State private var totalPrice=""
    @State private var totalDoublePrice=0.0
    
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
                    RequestConfirmed(selectedPlace: selectedPlace, tableID: tableID)
                } else if selected == "orders" {
                    OrdersView(selectedPlace: selectedPlace, tableID: tableID)
                } else if selected == "menu" {
                    MenuView(selectedPlaceName: selectedPlace,tableID: tableID, orderArray: $orderArray, totalPrice: $totalPrice, totalDoublePrice: $totalDoublePrice)
                }
            }.navigationTitle(selectedPlace+" Masa "+tableNum).navigationBarTitleDisplayMode(.inline)
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
    @StateObject private var connectToPlaceViewModel=GetConnectionInfoViewModel()
    @StateObject private var timerManager = TimerManager()
    @State var selectedPlace=""
    @State var tableID=""
    
    var body: some View {
            VStack{
                Text("Hoş geldin \(userInfo.firstName)")
                    .font(.title)
                Text("Masa ID: \(connectToPlaceViewModel.tableID)")
                Text("Masa Durumu: \(connectToPlaceViewModel.status)")
                Text("\(timerManager.hour) saat \(timerManager.min) dakikadır masadasınız")
                Group{
                    Text("Toplam Hesap : \(connectToPlaceViewModel.totalPrice)")
                    Text("Sizin hesabınız : \(connectToPlaceViewModel.userPrice)")
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.05)
                .background(Color("logoColor"))
                .foregroundColor(.white)
                .font(.headline)
                List{
                    Section(header: Text("Masanızdaki kişiler: \(connectToPlaceViewModel.people.count)").foregroundColor((Color("logoColor")))){
                        ForEach(connectToPlaceViewModel.people,id:\.self) { i in
                            HStack{
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                    Text(i)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Text("sipariş bekliyor")
                                        .font(.footnote)
                                        .fontWeight(.thin)
                                    Text("150₺")
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
                connectToPlaceViewModel.getConnectToPlaceInfoForBusiness(placeName: selectedPlace, tableID: tableID)
                connectToPlaceViewModel.getConnectToPlaceInfoForUser(placeName: selectedPlace, tableID: tableID)
            }
    }
}

struct MenuView: View {
    
    @StateObject private var menuViewModel=MenuViewModel()
    @State var selectedPlaceName=""
    @State var tableID=""
    @Binding var orderArray : [orderModel]
    @Binding var totalPrice : String
    @Binding var totalDoublePrice : Double
    
    var body: some View {
        VStack{
            List{
                Section(header: Text("Menüler")){
                    ForEach(menuViewModel.categories,id:\.self){ i in
                        NavigationLink(destination: SelectedMenuForUserView(placeName: selectedPlaceName, menuName: i, orderArray: $orderArray, totalDoublePrice: $totalDoublePrice, totalPrice: $totalPrice)) {
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
            menuViewModel.getMenu(placeName: selectedPlaceName)
        }
    }
}

struct SelectedMenuForUserView: View{
    
    @StateObject private var menuViewModel=MenuViewModel()
    @State var placeName=""
    @State var menuName=""
    @State private var selectedSubMenu=""
    @State private var showOrder=false
    @Binding var orderArray : [orderModel]
    @Binding var totalDoublePrice : Double
    @Binding var totalPrice : String
    
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
                                        
                                        if orderArray.contains(where:{$0.itemName == item.itemName}) {
                                            if let index = orderArray.firstIndex(where: {$0.itemName == item.itemName}) {
                                                orderArray[index].amount+=1
                                            }
                                        } else {
                                            orderArray.append((orderModel(statement: item.statement, price: item.price, itemName: item.itemName, status: "Sipariş bekliyor", amount: 1)))
                                        }
                                        
                                        calculateTotalPrice(price: item.price)
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
                if orderArray.isEmpty {
                    
                } else {
                    Button(action: {
                        showOrder.toggle()
                    }) {
                        Text("Sepeti Görüntüle")
                    }
                }
            }
            .navigationTitle(menuName).navigationBarTitleDisplayMode(.inline)
            .onAppear{
                menuViewModel.getSubMenu(placeName: placeName, menuName: menuName)
                menuViewModel.getItem(placeName: placeName)
            }
            .sheet(isPresented: $showOrder) {
                ConfirmOrdersView(orderArray: $orderArray, totalPrice: $totalPrice, totalDoublePrice: $totalDoublePrice)
            }
    }
    
    func calculateTotalPrice(price: String){
        var doublePrice=0.0
        doublePrice=Double(price)!
        totalDoublePrice+=doublePrice
        totalPrice=String(totalDoublePrice)
    }
}

struct ConfirmOrdersView: View {
    
    @StateObject private var orderViewModel=ConnectToPlaceViewModel()
    @Binding var orderArray : [orderModel]
    @Binding var totalPrice : String
    @Binding var totalDoublePrice : Double
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(orderArray) { item in
                        HStack{
                            Image("antrikot")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                            Spacer()
                            VStack(alignment: .leading, spacing:10){
                                HStack{
                                    Text(item.itemName)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: {
                                        deleteItem(item: item)
                                        deleteOrder(price: item.price, amount: item.amount)
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.title)
                                            .foregroundColor(.red)
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                Text(item.statement)
                                    .font(.footnote)
                                    .fontWeight(.thin)
                                HStack {
                                    Text(item.price+" ₺")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Button(action: {
                                        if item.amount > 1 {
                                            if let index = orderArray.firstIndex(where: {$0.id == item.id}) {
                                                orderArray[index].amount-=1
                                            }
                                            decreaseAmount(price: item.price)
                                        } else {
                                            deleteItem(item: item)
                                            deleteOrder(price: item.price, amount: item.amount)
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16,weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Text("\(item.amount)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .background(Color.black.opacity(0.06))
                                    Button(action: {
                                        if let index = orderArray.firstIndex(where: {$0.id == item.id}) {
                                            orderArray[index].amount+=1
                                        }
                                        changeAmount(price: item.price)
                                    }) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16,weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            VStack{
                HStack{
                    Text("Toplam Fiyat")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(String(totalDoublePrice)) ₺")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top,.horizontal])
                Button(action: {
                    
                    //database kaydet
                    
                }) {
                    Text("Siparişi ver")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    func deleteItem(item: orderModel){
        
        if let index = orderArray.index(of: item) {
            orderArray.remove(at: index)
        }
    }
    
    func changeAmount(price: String) {
        var doublePrice=0.0
        doublePrice=Double(price)!
        
        totalDoublePrice+=doublePrice
        totalPrice=String(totalDoublePrice)
    }
    
    func decreaseAmount(price: String) {
        var doublePrice=0.0
        doublePrice=Double(price)!
        
        totalDoublePrice-=doublePrice
        totalPrice=String(totalDoublePrice)
    }
    
    func deleteOrder(price: String, amount: Int){
        var doublePrice=0.0
        doublePrice=Double(price)!
        
        totalDoublePrice-=doublePrice * Double(amount)
        totalPrice=String(totalDoublePrice)
    }
}

struct OrdersView: View {
    
    @State var selectedPlace=""
    @State var tableID=""
    
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


