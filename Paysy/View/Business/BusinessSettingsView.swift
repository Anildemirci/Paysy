//
//  BusinessSettingsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI

struct BusinessSettingsView: View {
    
    @StateObject private var tablesInfo=BusinessInformationsViewModel()
    @State private var selected="menu"
    
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
                        MenuSettingsView()
                    } else {
                        TableSettingsView(placeName: tablesInfo.placeName)
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
    var body: some View {
        VStack{
            Text("menüüü")
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
