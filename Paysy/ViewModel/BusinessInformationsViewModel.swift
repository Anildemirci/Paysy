//
//  LocationInfoViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 18.06.2022.
//

import Foundation
import Firebase

class BusinessInformationsViewModel : ObservableObject {
    
    @Published var placeName=""
    @Published var ownerName=""
    @Published var phoneNumber=""
    @Published var address=""
    @Published var city=""
    @Published var town=""
    @Published var village=""
    @Published var street=""
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var businessArray=[String]()
    
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    //business info
    func getInfos(){
        firestoreDatabase.collection("Business").document(currentUser!.uid).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
                
            } else {
                if let village = snapshot?.get("Village") as? String {
                    self.village=village
                }
                if let street = snapshot?.get("Street") as? String {
                    self.street=street
                }
                if let placeName = snapshot?.get("Place Name") as? String {
                    self.placeName=placeName
                }
                if let ownerName = snapshot?.get("Owner's Name") as? String {
                    self.ownerName=ownerName
                }
                if let city = snapshot?.get("City") as? String {
                    self.city=city
                }
                if let address = snapshot?.get("Address") as? String {
                    self.address=address
                }
                if let town = snapshot?.get("Town") as? String {
                    self.town=town
                }
                if let phone = snapshot?.get("Phone") as? String {
                    self.phoneNumber=phone
                }
            }
        }
    }
    
    func updateInfo(){
        firestoreDatabase.collection("Business").document(currentUser!.uid).updateData(["Phone":phoneNumber,
                                                                                        "Village":village,
                                                                                        "Street":street,
                                                                                        "Address":(village)+",\(street)"+",\(town)"+"/\(city)",
                                                                                        "City":city,
                                                                                        "Town":town
                                                                                       ])
    }
    
    //business arrayi
    func businesses(){
        firestoreDatabase.collection("Business").getDocuments { snapshot, error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                for document in snapshot!.documents {
                    if let userEmail=document.get("Email") as? String {
                        self.businessArray.append(userEmail)
                    }
                }
            }
        }
    }
}
