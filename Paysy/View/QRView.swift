//
//  QRView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI
import CodeScanner

struct QRView: View {
    
    @State var isShowingScanner = false
    @State var scannedCode: String = "Scan a QR code to get started"
    @State var txt="test"
    @State var showPage=false
    @State var tableNumber=""
    @State var showAlert=false
    //@State var showingPlace=false
    @State var connected=false
    
    var body: some View {
        if connected == false {
            if showPage==false {
                VStack(spacing:10){
                    Text(scannedCode)
                    
                    Button(action: {
                        isShowingScanner=true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan QR Code")
                    }
                    .sheet(isPresented: $isShowingScanner) {
                        CodeScannerView(codeTypes: [.qr], completion: handleScan)
                    }
                    Text("Ya da şifre ile direkt arkadaşlarının masasına bağlan")
                    Button(action: {
                        showAlert.toggle()
                        enterTable(title: "Masaya Bağlan", Message: "Lütfen arkadaşlarınızın ekranında oluşturulan şifreyi giriniz.")
                    }) {
                        Text("Masaya Bağlan")
                    }
                }
            } else {
                VStack{
                    //qr okunduktan sonra gösterilcek ekran.
                    if showPage == true {
                        Button(action: {
                            showAlert.toggle()
                            enterTable(title: "Masa Numarası", Message: "Lütfen QR kod altında yazan masa numarasını giriniz.")
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
    
    
    func enterTable(title: String, Message: String){
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addTextField{ (number) in
            number.placeholder = "Masa numarası"
        }
        let proceed=UIAlertAction(title: "Tamam", style: .default) { (_) in
            //action
            tableNumber=alert.textFields![0].text!
            showAlert.toggle()
            connected.toggle()
        }
        
        let cancel = UIAlertAction(title: "İptal", style: .destructive, handler: nil)
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}



