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
    @State private var scannedCode: String = "Mekana bağlanmak için QR kodu okut"
    @State private var txt="test"
    
    @State private var showPage=false
    @State private var showAlert=false
    @State private var connected=true
    @State private var tablePassword=""
    
    var body: some View {
        if connected == false {
            if showPage==false {
                ZStack {
                    VStack(spacing:10){
                        Text(scannedCode)
                        
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
                            showAlert.toggle()
                        }) {
                            Text("Masaya Bağlan")
                        }
                    }
                    CustomAlertTFView(isShown:$showAlert, text: $tablePassword, title: "Masaya Bağlan", buttonName: "Ekle", hint: "masa şifresi") { menuName in
                        print(tablePassword)
                    }
                }
                
            } else {
                VStack{
                    //qr okunduktan sonra gösterilcek ekran.
                    if showPage == true {
                        Button(action: {
                            showAlert.toggle()
                            
                        }) {
                            Text("Masaya Bağlan")
                        }
                    }
                }
            }
        } else {
            ConnectToPlaceView()
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner=false
        
        switch result {
        case .success(let result):
            let details = result.string
            txt=details
            //showAlert.toggle()
            showPage.toggle()
            print(txt)
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



