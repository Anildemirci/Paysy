//
//  GetConnectionInfoViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 12.07.2022.
//

import Foundation
import Firebase

class GetConnectionInfoViewModel : ObservableObject {
    
    private let currentUser=Auth.auth().currentUser
    private let firestoreDatabase=Firestore.firestore()
    
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
    @Published var userPrice=""
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var tableNumber=""
    @Published var tableID=""
    @Published var placeName=""
    @Published var checkUser=""
    @Published var tableIDFromCheck=""
    @Published var placeNameFromCheck=""
    @Published var documentIDForUser=""
    
    func getConnectToPlaceInfoForBusiness(placeName:String, tableID: String){
        
        firestoreDatabase.collection("ConnectToPlaceForBusiness").document(placeName).collection(placeName).document(tableID).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                if let totalPrice=snapshot?.get("Total Price") as? String {
                    self.totalPrice=totalPrice
                }
                if let placeName=snapshot?.get("Place Name") as? String {
                    self.placeName=placeName
                }
                if let getPeople=snapshot?.get("People") as? [String] {
                    self.people=getPeople
                }
                if let tableNum=snapshot?.get("Table Number") as? String {
                    self.tableNumber=tableNum
                }
                if let status=snapshot?.get("Status") as? String {
                    self.status=status
                }
                if let tableID=snapshot?.get("TableID") as? String {
                    self.tableID=tableID
                }
            }
        }
    }
    
    func getConnectToPlaceInfoForUser(placeName: String, tableID: String) {
        
        firestoreDatabase.collection("ConnectToPlaceForUser").document(currentUser!.uid).collection(placeName).whereField("TableID", isEqualTo: tableID).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    self.documentIDForUser=document.documentID
                }
            }
            self.firestoreDatabase.collection("ConnectToPlaceForUser").document(self.currentUser!.uid).collection(placeName).document(self.documentIDForUser).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    if let totalPrice=snapshot?.get("Total Price") as? String {
                        self.userPrice=totalPrice
                    }
                    if let orders=snapshot?.get("Orders") as? [String] {
                        self.orders=orders
                    }
                }
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
                if let placeName=snapshot?.get("Place Name") as? String {
                    self.placeNameFromCheck=placeName
                }
                if let tableID=snapshot?.get("TableID") as? String {
                    self.tableIDFromCheck=tableID
                }
                if let tableNum=snapshot?.get("Table Number") as? String {
                    self.tableNumber=tableNum
                }
            }
        }
    }
    
}
