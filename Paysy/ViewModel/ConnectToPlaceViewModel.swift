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
    @Published var tableNumber=""
    @Published var tableID=""
    @Published var placeNameWithPass=""
    @Published var tableNumberWithPass=""
    
    @Published var orderArray = [orderModel]()
    
    @Published var orderArray2 = [orderModel]()
    @Published var statement2=""
    @Published var itemName2=""
    @Published var price=""
    @Published var status2=""
    @Published var amount2=""
    
    
    func randomPassword(){
        let len=6
        let char = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let rndPswd = String((0..<len).compactMap{ _ in char.randomElement() })
        tableID=rndPswd
        tableIDFromPass=rndPswd
    }
    
    func getCurrentTime(){
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        formatter.timeZone=TimeZone(abbreviation: "UTC+3")
        currentTime=formatter.string(from: date)
    }
    
    func requestToPlace(placeName: String, userFullName: String){
        
        randomPassword()
        let firestoreUser2=["User":Auth.auth().currentUser!.uid,
                            "Email":Auth.auth().currentUser!.email!,
                            "Place Name":placeName,
                            "TableID":self.tableID,
                            "Table Number":self.tableNumber,
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
        
        let firestoreUser2=["User":Auth.auth().currentUser!.uid,
                            "Email":Auth.auth().currentUser!.email!,
                            "Place Name":placeName,
                            "Table Number":self.tableNumber,
                            "TableID":self.tableID,
                            "Date":currentTime] as [String:Any]
        
        firestoreDatabase.collection("CheckTable").document(self.tableID).setData(firestoreUser2) 
        
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
        
        firestoreDatabase.collection("ConnectToPlaceForBusiness").document(placeName).collection(placeName).document(tableID).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Masa isteği gönderildi."
            }
        }
        
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
    }
    
    //şifre ile direkt masaya giriş
    func connectToPlaceWithPass(userFullName: String, tableID: String) {
        getCurrentTime()
        //tableid ile eşleşen mekanın ismini buluyor
        firestoreDatabase.collection("CheckTable").whereField("TableID", isEqualTo: tableID).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    if let placeName=document.get("Place Name") as? String {
                        self.placeNameWithPass=placeName
                    }
                    if let tableNum=document.get("Table Number") as? String {
                        self.tableNumberWithPass=tableNum
                    }
                }
            }
            //o mekandaki insanları alıyor
            self.firestoreDatabase.collection("ConnectToPlaceForBusiness").document(self.placeNameWithPass).collection(self.placeNameWithPass).document(tableID).getDocument { (snapshot, error) in
                if error == nil {
                    self.people.removeAll(keepingCapacity: false)
                        if let peopleArray=snapshot?.get("People") as? [String]{
                            self.people=peopleArray
                        }
                }
                //şifre ile katılan kullanıcıyı o insanlara ekliyor
                self.people.append(userFullName)
                let addPerson=["People":self.people] as [String:Any]
                self.firestoreDatabase.collection("ConnectToPlaceForBusiness").document(self.placeNameWithPass).collection(self.placeNameWithPass).document(tableID).setData(addPerson, merge: true) { error in
                    if error != nil {
                        self.alertTitle="Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                    } else {
                        
                    }
                }
                
                //şifre ile katılan insan için ayrıca kayıt alıyor
                let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                   "Email":Auth.auth().currentUser!.email!,
                                   "UserFullName":userFullName,
                                   "Place Name":self.placeNameWithPass,
                                   "Table Number":self.tableNumberWithPass,
                                   "TableID":tableID,
                                   "Customer Note":self.customerNote,
                                   "Orders":self.orders,
                                   "People":self.people,
                                   "Total Price":self.totalPrice,
                                   "Payment Details":"",
                                   "Status":"Onay Bekliyor",
                                   "Date":self.currentTime] as [String:Any]
                
                self.firestoreDatabase.collection("ConnectToPlaceForUser").document(self.currentUser!.uid).collection(self.placeNameWithPass).document(self.currentTime).setData(firestoreUser) { error in
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
                
                let firestoreUser2=["User":Auth.auth().currentUser!.uid,
                                    "Email":Auth.auth().currentUser!.email!,
                                    "Place Name":self.placeNameWithPass,
                                    "TableID":tableID,
                                    "Table Number":self.tableNumberWithPass,
                                    "Status":"Onaylandı",
                                    "Date":self.currentTime] as [String:Any]
                self.firestoreDatabase.collection("ConnectToPlaceForUser").document(self.currentUser!.uid).setData(firestoreUser2) { error in
                    
                    if error != nil {
                        self.alertTitle="Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                    } else {
                        
                    }
                }
                
            }
        }
    }
    
    //kullanılmadı
    func orderItem(placeName: String,tableID: String, orderNo: String){
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "Item Name":self.itemName,
                           "Price":self.price,
                           "Note":self.customerNote,
                           "Status":"Onay bekliyor",
                           "Date":self.currentTime] as [String:Any]
        
        firestoreDatabase.collection("Orders").document(placeName).collection(tableID).document(orderNo).setData(firestoreUser) {error in
            if error != nil {
                
            } else {
                
            }
        }
    }
    
    
    
}
