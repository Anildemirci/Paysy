//
//  QRView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI
import CodeScanner

struct QRView: View {
    
    @State private var isShowingScanner = false
    @State private var txt="test"
    
    @State private var enterWithPass=false
    @State private var showAlert=false
    @State private var tablePassword=""
    @State private var selectedPlace=""
    
    @StateObject private var connectToPlaceViewModel=ConnectToPlaceViewModel()
    @StateObject private var userInfo=UserInformationsViewModel()
    
    var body: some View {
        if connectToPlaceViewModel.checkUser == "" {
                ZStack {
                    VStack(spacing:10){
                        Text("Mekana bağlanmak için QR kodu okut")
                        
                        Button(action: {
                            isShowingScanner=true
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                            Text("Qr kodu okut")
                        }
                        .sheet(isPresented: $isShowingScanner) {
                            CodeScannerView(codeTypes: [.qr], completion: handleScan)
                        }
                        Text("Ya da şifre ile direkt arkadaşlarının masasına bağlan")
                        Button(action: {
                            enterWithPass.toggle()
                        }) {
                            Text("Masaya Şifre ile Bağlan")
                        }
                    }
                    CustomAlertTFView(isShown:$enterWithPass, text: $tablePassword, title: "Masaya Bağlan", buttonName: "Bağlan", hint: "masa şifresi") { tablePass in
                        connectToPlaceViewModel.connectToPlaceWithPass(placeName: "DorockXL", userFullName: userInfo.firstName+" "+userInfo.lastName, tableID: tablePassword)
                    }
                    CustomAlertTFView(isShown:$showAlert, text: $connectToPlaceViewModel.tableNumber, title: "\(selectedPlace) Bağlan", buttonName: "Bağlan", hint: "masa numarası") { tableNumber in
                        connectToPlaceViewModel.requestToPlace(placeName: selectedPlace, userFullName: userInfo.firstName+" "+userInfo.lastName)
                        connectToPlaceViewModel.connectToPlace(placeName: selectedPlace, userFullName: userInfo.firstName+" "+userInfo.lastName)
                    }
                    
                    .alert(isPresented: $connectToPlaceViewModel.showAlert, content: {
                        Alert(title: Text(connectToPlaceViewModel.alertTitle), message: Text(connectToPlaceViewModel.alertMessage), dismissButton: .destructive(Text("Tamam")))
                    })
                }.onAppear{
                    userInfo.getInfos()
                    connectToPlaceViewModel.checkUserInPlace()
                }
        } else if connectToPlaceViewModel.checkUser == "Onaylandı" || connectToPlaceViewModel.checkUser == "Onay bekliyor" {
            ConnectToPlaceView()
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner=false
        
        switch result {
        case .success(let result):
            let details = result.string
            txt=details
            selectedPlace=txt
            showAlert.toggle()
            guard details.count == 2 else { return }
            
        case .failure(let error):
            print("Hata: \(error.localizedDescription)")
        }
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}

var selectionTab=0

