//
//  BusinessSettingsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI

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
        //BusinessSettingsView()
        AddItemView()
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
    
    var body: some View {
        VStack{
            HStack{
                Text("Menü kategorisi oluştur")
                    .font(.headline)
                    .frame(height: 50)
                TextField("yemekler, içececekler", text: $menuName)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20,weight: .semibold))
                    .foregroundColor(.black)
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
            }
            Button(action: {
                menuViewModel.categories.append(menuName)
                menuViewModel.addMenu(placeName: placeName)
                menuName=""
            }) {
                Text("Ekle")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                .background(Color.green)
                .cornerRadius(25)
            }
            if menuViewModel.categories.isEmpty {
                Text("Henüz menü eklenmedi.")
            } else {
                Text("Düzenlemek istediğiniz bölüme tıklayın")
                    .font(.headline)
                ForEach(menuViewModel.categories,id:\.self) { i in
                    NavigationLink(destination: AddMenuItemView(menuName:i, placeName: placeName)) {
                        Text(i)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }.onAppear{
            menuViewModel.getMenu(placeName: placeName)
        }
    }
}

struct AddMenuItemView: View {
    @State var menuName=""
    @State private var subMenuName=""
    @State private var selectedSubMenu=""
    @State private var selection="Lütfen kategori seçiniz"
    @StateObject private var menuViewModel=MenuViewModel()
    @State var placeName=""
    @State private var show=false
    @State private var editName=""
    @State private var editPrice=""
    @State private var editStatement=""
    
    var body: some View {
        VStack {
            Spacer()
                HStack{
                    Text("Menü alt kategorisi oluştur")
                        .font(.headline)
                        .frame(height: 50)
                    TextField("kırmızı et, alkollü içecekler", text: $subMenuName)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20,weight: .semibold))
                        .foregroundColor(.black)
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
                Button(action: {
                    menuViewModel.subCategories.append(subMenuName)
                    menuViewModel.addSubMenu(placeName: placeName, menuName: menuName, subCategories: subMenuName)
                    subMenuName=""
                }) {
                    Text("Ekle")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(25)
                }
            
            if menuViewModel.subCategories.isEmpty {
                Text("Daha alt menü eklemedi.")
            } else {
                
                    Text("Ürün eklemek istediğiniz kategoriyi seçiniz")
                        .foregroundColor(Color.black)
                        .font(.headline)
                        .frame(height: 50)
                    Spacer()
                    ForEach(menuViewModel.subCategories,id:\.self) { i in
                        NavigationLink(destination: AddItemView(menuName: menuName, subMenuName: i, placeName: placeName)) {
                            Text(i)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                        }
                    }
                Text("Ürünü düzenlemek için tıklayın.")
                    .foregroundColor(Color.black)
                    .font(.headline)
                    .frame(height: 50)
                Spacer()
                List(menuViewModel.subCategories,id:\.self){ i in
                    Section(header: Text(i)) {
                        ForEach(menuViewModel.allItems){ item in
                            if item.SubMenuType == i{
                                HStack {
                                    Text(item.itemName)
                                    Spacer()
                                    Text(item.price)
                                }.onTapGesture {
                                    selectedSubMenu=item.SubMenuType
                                    editName=item.itemName
                                    editPrice=item.price
                                    editStatement=item.statement
                                    show.toggle()
                                }
                            }
                        }.onDelete(perform: menuViewModel.deleteItem)
                    }
                }.listStyle(.sidebar)
                Spacer()
            }
        }
        .onAppear{
            menuViewModel.getSubMenu(placeName: placeName, menuName: menuName)
            menuViewModel.getItem(placeName: placeName )
        }
    }
}

struct AddItemView: View{
    
    @StateObject private var menuViewModel=MenuViewModel()
    @State var menuName=""
    @State var subMenuName=""
    @State var placeName=""
    
    var body: some View {
        Spacer()
            VStack{
                HStack{
                    Text("Ürün Adı")
                        .font(.headline)
                        .frame(height: 50)
                    TextField("Hamburger,Pizza,Bira", text: $menuViewModel.itemName)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20,weight: .semibold))
                        .foregroundColor(.black)
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
                HStack{
                    Text("Fiyatı")
                        .font(.headline)
                        .frame(height: 50)
                    TextField("100 ₺", text: $menuViewModel.price)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20,weight: .semibold))
                        .foregroundColor(.black)
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
                HStack{
                    Text("Ürün Bilgisi")
                        .font(.headline)
                        .frame(height: 50)
                    TextField("içerik", text: $menuViewModel.statement)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20,weight: .semibold))
                        .foregroundColor(.black)
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
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
