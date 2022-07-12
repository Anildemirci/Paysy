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
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var tableNumber=""
    @Published var tableID=""
    @Published var placeName=""
    
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
            }
        }
    }
}
