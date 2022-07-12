//
//  ConnectToPlaceViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 12.07.2022.
//

import Foundation
import Firebase

class ConnectToPlaceViewModel : ObservableObject {
    
    private let currentUser=Auth.auth().currentUser
    private let firestoreDatabase=Firestore.firestore()
    private var currentTime=""
    
    @Published var categories=""
    @Published var subCategories=""
    @Published var itemName=""
    @Published var itemPrice=""
    @Published var statement=""
    @Published var customerNote=""
    @Published var status=""
    @Published var orders=[String]()
    @Published var people=[String]()
    @Published var totalPrice=""
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var checkUser=""
    @Published var tableNumber=""
    @Published var tableID=""
    @Published var placeNameForConnect=""
    
    func randomPassword(){
        let len=6
        let char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let rndPswd = String((0..<len).compactMap{ _ in char.randomElement() })
        tableID=rndPswd
    }
    
    func getCurrentTime(){
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        formatter.timeZone=TimeZone(abbreviation: "UTC+3")
        currentTime=formatter.string(from: date)
    }
    
    func requestToPlace(placeName: String, userFullName: String){
        
        let firestoreUser2=["User":Auth.auth().currentUser!.uid,
                            "Email":Auth.auth().currentUser!.email!,
                            "Place Name":placeName,
                            "Status":"Onay Bekliyor",
                            "Date":currentTime] as [String:Any]
        firestoreDatabase.collection("ConnectToPlaceForUser").document(currentUser!.uid).setData(firestoreUser2) { error in
            
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
            } else {
                
            }
        }
    }
    
    //masaya bağlanma isteği qr ile
    func connectToPlace(placeName: String, userFullName: String){
        
        getCurrentTime()
        people.append(userFullName)
        randomPassword()
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "UserFullName":userFullName,
                           "Place Name":placeName,
                           "Table Number":self.tableNumber,
                           "TableID":self.tableID,
                           "Customer Note":self.customerNote,
                           "Orders":self.orders,
                           "People":self.people,
                           "Total Price":self.totalPrice,
                           "Payment Details":"",
                           "Status":"Onay Bekliyor",
                           "Date":currentTime] as [String:Any]
        
        firestoreDatabase.collection("ConnectToPlaceForUser").document(currentUser!.uid).collection(placeName).document(currentTime).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Masa isteği gönderildi."
                self.showAlert.toggle()
                selectionTab=2
            }
        }
        
        firestoreDatabase.collection("ConnectToPlaceForBusiness").document(placeName).collection(placeName).document(tableID).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Masa isteği gönderildi."
                self.showAlert.toggle()
            }
        }
    }
    
    //şifre ile direkt masaya giriş
    func connectToPlaceWithPass(placeName: String, userFullName: String, tableID: String) {
        getCurrentTime()
        //düzelt
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "UserFullName":userFullName,
                           "Place Name":placeName,
                           "Table Number":self.tableNumber,
                           "TableID":tableID,
                           "Customer Note":self.customerNote,
                           "Orders":self.orders,
                           "People":self.people,
                           "Total Price":self.totalPrice,
                           "Payment Details":"",
                           "Status":"Onay Bekliyor",
                           "Date":currentTime] as [String:Any]
        
        let addPerson=["People":self.people] as [String:Any]
        
        firestoreDatabase.collection("ConnectToPlaceForBusiness").document(placeName).collection(placeName).document(tableID).updateData(addPerson) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Masa isteği gönderildi."
                self.showAlert.toggle()
            }
        }
        
    }
    
    
    //kullanıcı şu an masada mı değil mi?
    func checkUserInPlace(){
        
        firestoreDatabase.collection("ConnectToPlaceForUser").document(currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                if let status = snapshot?.get("Status") as? String {
                    self.checkUser=status
                }
            }
        }
    }
    
    
    
    //kullanılmadı
    func orderItem(placeName: String,tableID: String){
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "Place Name":placeName,
                           "TableID":tableID,
                           "Categories":self.categories,
                           "SubCategories":self.subCategories,
                           "Item Name":self.itemName,
                           "Item Price":self.itemPrice,
                           "Statement":self.statement,
                           "Customer Note":self.customerNote,
                           "Status":self.status,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("Orders").document(currentUser!.uid).collection(tableID).document(placeName).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Ürün sipariş edildi."
                self.showAlert.toggle()
            }
        }
    }
    
    
    
}
