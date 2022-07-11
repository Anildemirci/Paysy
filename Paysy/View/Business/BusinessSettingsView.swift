//
//  BusinessSettingsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI
//alert koy
//kontrolleri gerçekleştir öyle ekle ürünleri

struct BusinessSettingsView: View {
    
    @StateObject private var tablesInfo=BusinessInformationsViewModel()
    @State private var selected=""
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button(action: {
                        selected="menu"
                    }) {
                        Text("Menü Ayarları")
                            .foregroundColor(selected=="menu" ? Color.white : Color.black)
                            .frame(width: 100, height: 50)
                            .background(selected=="menu" ? Color("logoColor") : Color.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        selected="table"
                    }) {
                        Text("Masa Ayarları")
                            .foregroundColor(selected=="table" ? Color.white : Color.black)
                            .frame(width: 100, height: 50)
                            .background(selected=="table" ? Color("logoColor") : Color.white)
                            .cornerRadius(10)
                    }
                }.padding()
                    if selected == "menu" {
                        MenuSettingsView(placeName: tablesInfo.placeName)
                    } else if selected == "table" {
                        TableSettingsView(placeName: tablesInfo.placeName,city: tablesInfo.city,town: tablesInfo.town)
                    } else {
                        Text("Seçiniz")
                    }
                Spacer()
            }
            .navigationTitle("Ayarlar").navigationBarTitleDisplayMode(.inline)
            .onAppear{
                tablesInfo.getInfos()
            }
            .alert(isPresented: $tablesInfo.showAlert, content: {
                Alert(title: Text(tablesInfo.alertTitle), message: Text(tablesInfo.alertMessage), dismissButton: .default(Text("Tamam")))
            })
        }
    }
}

struct BusinessSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessSettingsView()
    }
}

struct TableSettingsView: View {
    @StateObject private var tablesInfo=BusinessInformationsViewModel()
    
    @State private var partNumber=""
    @State private var tableName=""
    @State private var enteredName=0
    @State var placeName=""
    @State var city=""
    @State var town=""
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Toplam masa sayısınız")) {
                    TextField("50,100,150 vs", text: $tablesInfo.totalTable)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Mekan düzeniniz kaç bölümden oluşuyor(bahçe,katlar,vb.)")){
                    TextField("1,2,3 vs.", text: $partNumber)
                        .keyboardType(.numberPad)
                }
                if partNumber != "" {
                    Section(header: Text("Bölümlere isim veriniz.")){
                        HStack{
                            let intNumber=Int(partNumber)!
                            TextField("isim girin", text: $tableName)
                                .allowsHitTesting(enteredName==intNumber ? false : true)
                            Button(action: {
                                enteredName+=1
                                tablesInfo.parts.append(tableName)
                                tableName=""
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:25)
                                    .foregroundColor(.green)
                                    //.overlay(Rectangle().stroke(Color.black,lineWidth:1))
                            }
                            .disabled(enteredName==intNumber ? true : false)
                        }
                    }
                        Section(header: Text("Eklediğiniz bölümler")) {
                            ForEach(tablesInfo.parts,id:\.self){ i in
                                    Text("\(i)")
                            }
                        }
                }
            }.frame(maxHeight: (partNumber == "" ? 250 : UIScreen.main.bounds.height * 0.7))
            if partNumber != "" {
                Button(action: {
                    enteredName=0
                    partNumber=""
                    print(tablesInfo.city)
                    print(tablesInfo.town)
                    tablesInfo.setTables(placeName: placeName, city: city, town: town)
                }) {
                    Text("Onayla")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            } else {
                List{
                    Section(header: Text("Düzenlemek istediğiniz bölüme tıklayın")) {
                        ForEach(tablesInfo.getTableName,id:\.self) { i in
                            NavigationLink(destination: PartsView(selectedPart: i)) {
                                Text(i)
                            }
                        }
                    }
                }.listStyle(.plain)
            }
        }
        .onAppear{
            tablesInfo.getTables(placeName: placeName)
        }
    }
}

struct MenuSettingsView: View {
    
    @State var placeName=""
    @State private var menuName=""
    @StateObject private var menuViewModel=MenuViewModel()
    @State private var showAlert=false
    @State private var dark=false
    
    var body: some View {
        ZStack {
            VStack{
                if menuViewModel.categories.isEmpty {
                    Text("Henüz menü eklenmedi.")
                        .font(.headline)
                } else {
                    List {
                        Section (header: Text("Düzenlemek istediğiniz bölüme tıklayın").multilineTextAlignment(.center)) {
                            ForEach(menuViewModel.categories,id:\.self) { i in
                                NavigationLink(destination: AddMenuItemView(menuName:i, placeName: placeName)) {
                                    Text(i)
                                        .foregroundColor(Color.black)
                                }
                            }.onDelete(perform: menuViewModel.deleteMenu)
                        }
                    }.listStyle(.plain)
                }
                Spacer()
                    .navigationTitle("Menüler").navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing:
                                            Button(action: {
                        showAlert.toggle()
                    }){
                        Text("Kategori Oluştur")
                            .foregroundColor(.white)
                    })
            }
            .onAppear{
                menuViewModel.getMenu(placeName: placeName)
                placeNameForDeleteItem=placeName
            }
            CustomAlertTFView(isShown:$showAlert,text: $menuName,title: "Kategori Ekle", buttonName: "Ekle", hint: "Ana Yemekler, İçecekler") { menuName in
                menuViewModel.categories.append(menuName)
                menuViewModel.addMenu(placeName: placeName)
                self.menuName=""
            }
        }
    }
}

struct AddMenuItemView: View {
    @State var menuName=""
    @State private var subMenu=""
    @State private var selection="Lütfen kategori seçiniz"
    @StateObject private var menuViewModel=MenuViewModel()
    @State var placeName=""
    @State private var show=false
    @State private var showAlert=false
    
    var body: some View {
        ZStack {
            VStack{
                if menuViewModel.subCategories.isEmpty {
                    Text("Daha alt menü eklemedi.")
                } else {
                    List{
                        Section(header:Text("Ürün eklemek istediğiniz kategoriyi seçiniz").multilineTextAlignment(.center)){
                            ForEach(menuViewModel.subCategories,id:\.self) { i in
                                    NavigationLink(destination:SubMenuView(placeName: placeName, menuName: menuName,subMenuName: i)) {
                                        Text(i)
                                    }
                            }.onDelete(perform: menuViewModel.deleteSubMenu)
                        }
                    }.listStyle(.plain)
                }
                Spacer()
                    .navigationTitle(menuName).navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing:
                                            Button(action: {
                        showAlert.toggle()
                    }){
                        Text("Alt Kategori Oluştur")
                            .foregroundColor(.white)
                    })
            }
            .onAppear{
                menuViewModel.getSubMenu(placeName: placeName, menuName: menuName)
                //menuViewModel.getItem(placeName: placeName )
                menuNameForDelete=menuName
                placeNameForDeleteItem=placeName
        }
            CustomAlertTFView(isShown:$showAlert,text: $subMenu,title: "Alt Kategori Ekle", buttonName: "Ekle", hint: "Kırmızı Etler, Kırmızı Şaraplar") { subMenu in
                menuViewModel.subCategories.append(subMenu)
                menuViewModel.addSubMenu(placeName: placeName, menuName: menuName, subCategories: subMenu)
                self.subMenu=""
            }
        }
    }
}
//ürün ekleyince anlık güncelle ve silince
struct SubMenuView: View {
    
    @StateObject private var menuViewModel=MenuViewModel()
    @State private var editName=""
    @State private var editPrice=""
    @State private var editStatement=""
    @State private var selectedSubMenu=""
    @State private var show=false
    @State private var editShow=false
    @State var placeName=""
    @State var menuName=""
    @State var subMenuName=""
    
    var body: some View {
        VStack{
            if menuViewModel.allItems.isEmpty {
                Text("Henüz ürün eklenmedi.")
                    .font(.headline)
            } else {
                List{
                    Section(header:Text("Düzenlemek istediğiniz ürüne tıklayın silmek için sola kaydırın").multilineTextAlignment(.center)){
                        ForEach(menuViewModel.allItems){ item in
                            if item.SubMenuType == subMenuName {
                                HStack {
                                    Text(item.itemName)
                                    Spacer()
                                    Text(item.price)
                                }.onTapGesture {
                                    selectedSubMenu=item.SubMenuType
                                    editName=item.itemName
                                    editPrice=item.price
                                    editStatement=item.statement
                                    print(editName)
                                    editShow.toggle()
                                }
                            }
                        }.onDelete(perform: menuViewModel.deleteItem)
                    }
                }.listStyle(.plain)
                .navigationTitle(subMenuName).navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                    show.toggle()
                }){
                    Text("Ürün Ekle")
                        .foregroundColor(.white)
                })
            }
        }
        .onAppear{
            menuViewModel.getItem(placeName: placeName)
            placeNameForDeleteItem=placeName
        }
        .sheet(isPresented: $show) {
            AddItemView(menuName: menuName, subMenuName: subMenuName, placeName: placeName)
        }
        .sheet(isPresented: $editShow) {
            AddItemView(menuName: menuName, subMenuName: subMenuName, placeName: placeName,editName:editName,editPrice:editPrice,editStatement: editStatement)
        }
    }
}

struct AddItemView: View{
    
    @StateObject private var menuViewModel=MenuViewModel()
    @State var menuName=""
    @State var subMenuName=""
    @State var placeName=""
    @State var editName=""
    @State var editPrice=""
    @State var editStatement=""
    
    var body: some View {
        Spacer()
            VStack{
                Form{
                    Section(header: Text("Ürün Adı")){
                        TextField("Hamburger,Pizza,Bira", text: $menuViewModel.itemName)
                    }
                    Section(header: Text("Fiyatı")){
                        TextField("100 ₺", text: $menuViewModel.price)
                    }
                    Section(header: Text("Fiyatı")){
                        TextField("içerik", text: $editName)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.4)
                Button(action: {
                    menuViewModel.addItem(placeName: placeName, menuName: menuName, subCategories: subMenuName)
                }) {
                    Text("Ekle")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                Spacer()
                    .navigationTitle(subMenuName).navigationBarTitleDisplayMode(.inline)
            }
    }
}

struct PartsView: View {
    
    @State var selectedPart=""
    @State var numberTable=""
    @State var selection=Set<String>()
    @State var editMode: EditMode = .active
    @StateObject private var partsInfo=BusinessInformationsViewModel()
    
    @State var features=["Full bar mevcut","İç Mekan","Sigara İçme Alanı","Kokteyl servisi mevcut","Rezervasyon önerilir","Vegan Seçenekler Mevcut","Dış Mekan","Wifi"]
    
    var body: some View{
        VStack{
            Form{
                Section(header: Text("Bu bölümdeki masa sayısı")) {
                    TextField("25,50,75 vb", text: $partsInfo.totalTable)
                        .keyboardType(.numberPad)
                }
            }.frame(maxHeight: 150)
            Section(header: Text("Bu bölümdeki özellikleri işaretleyin ve kaydedin")) {
                List(features,id:\.self,selection: $selection) { i in
                    Text(i)
                }.listStyle(.plain).environment(\.editMode, $editMode)
            }
            Button(action: {
                partsInfo.features=[String](selection)
                partsInfo.setPartInfo(placeName: partsInfo.placeName, partName: selectedPart)
                selection.removeAll(keepingCapacity: false)
            }) {
                Text("Onayla")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .navigationTitle(selectedPart).navigationBarTitleDisplayMode(.inline)
        .onAppear{
            partsInfo.getInfos()
        }
    }
}
