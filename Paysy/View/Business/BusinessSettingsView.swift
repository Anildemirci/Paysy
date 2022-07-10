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
                            .foregroundColor(selected=="menu" ? Color.black : Color.black.opacity(0.4))
                    }
                    Button(action: {
                        selected="table"
                    }) {
                        Text("Masa Ayarları")
                            .foregroundColor(selected=="table" ? Color.black : Color.black.opacity(0.4))
                    }
                }
                ScrollView(.vertical, showsIndicators: false){
                    if selected == "menu" {
                        MenuSettingsView(placeName: tablesInfo.placeName)
                    } else if selected == "table" {
                        TableSettingsView(placeName: tablesInfo.placeName)
                    } else {
                        Text("Seçiniz")
                    }
                }
            }
            .padding()
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
    
    var body: some View {
        VStack{
            HStack{
                Text("Toplam kaç masa")
                    .font(.headline)
                    .frame(height: 50)
                TextField("örn 5", text: $tablesInfo.totalTable)
                    .frame(width: 50, height: 50)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20,weight: .semibold))
                    .foregroundColor(.black)
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
            }
            Spacer(minLength: 25)
            HStack{
                Text("Mekan düzeniniz kaç bölümden oluşuyor(bahçe,katlar,vb.)")
                    .font(.headline)
                    .frame(height: 50)
                TextField("örn 3", text: $partNumber)
                    .frame(width: 50, height: 50)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20,weight: .semibold))
                    .foregroundColor(.black)
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
            }
            Spacer(minLength: 25)
            if partNumber != "" {
                HStack{
                    Text("Bölümlere isim veriniz.")
                        .scaledToFill()
                        .font(.headline)
                        .frame(height: 50)
                    
                    let intNumber=Int(partNumber)!
                    TextField("isim girin", text: $tableName)
                        .padding()
                        .allowsHitTesting(enteredName==intNumber ? false : true)
                        .frame(height: 50)
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        
                    Button(action: {
                        enteredName+=1
                        tablesInfo.parts.append(tableName)
                        tableName=""
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25,height: 50)
                            .foregroundColor(.green)
                            //.overlay(Rectangle().stroke(Color.black,lineWidth:1))
                    }
                    .disabled(enteredName==intNumber ? true : false)
                }
                
                Spacer(minLength: 25)
                ForEach(tablesInfo.parts,id:\.self){ i in
                        Text("\(i)")
                }
                Button(action: {
                    enteredName=0
                    partNumber=""
                    tablesInfo.setTables(placeName: tablesInfo.placeName, city: tablesInfo.city, town: tablesInfo.town)
                }) {
                    Text("Onayla")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.green)
                        .cornerRadius(25)
                }
            } else {
                Text("Düzenlemek istediğiniz bölüme tıklayın")
                    .font(.headline)
                ForEach(tablesInfo.getTableName,id:\.self) { i in
                    NavigationLink(destination: PartsView(selectedPart: i)) {
                        Text(i)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                    }
                }
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
        VStack(spacing:10){
            if menuViewModel.categories.isEmpty {
                Text("Henüz menü eklenmedi.")
            } else {
                Text("Düzenlemek istediğiniz bölüme tıklayın")
                    .font(.headline)
                ForEach(menuViewModel.categories,id:\.self) { i in
                    NavigationLink(destination: AddMenuItemView(menuName:i, placeName: placeName)) {
                        Text(i)
                            .foregroundColor(Color.black)
                    }
                    Divider()
                }
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
        }.padding()
        .onAppear{
            menuViewModel.getMenu(placeName: placeName)
        }
        CustomAlertTFView(isShown:$showAlert,text: $menuName,title: "Kategori Ekle", buttonName: "Ekle", hint: "Ana Yemekler, İçecekler") { menuName in
            menuViewModel.categories.append(menuName)
            menuViewModel.addMenu(placeName: placeName)
            self.menuName=""
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
            VStack(spacing:10) {
                if menuViewModel.subCategories.isEmpty {
                    Text("Daha alt menü eklemedi.")
                } else {
                    List{
                        Section(header:Text("Ürün eklemek istediğiniz kategoriyi seçiniz")){
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
            }.padding()
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
        VStack(spacing:10){
            Section(header:Text("Düzenlemek istediğiniz ürüne tıklayın silmek için sola kaydırın").multilineTextAlignment(.center)){
                List{
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
                }.listStyle(.plain)
            }
            .navigationTitle(subMenuName).navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                show.toggle()
            }){
                Text("Ürün Ekle")
                    .foregroundColor(.white)
            })
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
                    .cornerRadius(25)
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
            HStack{
                Text("Bu bölümde toplam kaç masa")
                    .font(.headline)
                    .frame(height: 50)
                TextField("örn 50", text: $partsInfo.totalTable)
                    .frame(width: 50, height: 50)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20,weight: .semibold))
                    .foregroundColor(.black)
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
            }
            Text("Bu bölümdeki özellikleri işaretleyin ve kaydedin").font(.headline)
            List(features,id:\.self,selection: $selection) { i in
                Text(i)
            }.listStyle(.plain).environment(\.editMode, $editMode)
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
                    .cornerRadius(25)
            }
        }
        .navigationTitle(selectedPart).navigationBarTitleDisplayMode(.inline)
        .onAppear{
            partsInfo.getInfos()
        }
    }
}
