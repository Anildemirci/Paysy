//
//  BusinessesViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 6.07.2022.
//

import Foundation
import Firebase


class BusinessesViewModel : ObservableObject {
    
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var nameArray=[String]()
    @Published var townArray=[townNameModel]()
    @Published var businessArray=[String]()
    
    func getTowns(){
        
        firestoreDatabase.collection("Business").order(by: "Town",descending: false).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.townArray.removeAll(keepingCapacity: false)
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let Town=document.get("Town") as? String {
                            if self.nameArray.contains(Town) {
                                //zaten içeriyor
                            } else{
                                self.nameArray.append(Town)
                                self.townArray.append(townNameModel(town: Town))
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func getBusinesses(town:String){
        
        firestoreDatabase.collection("Business").order(by: "Place Name",descending: false).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.businessArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        if let Name=document.get("Town") as? String {
                            if Name==town {
                                let businessName=document.get("Place Name") as! String
                                self.businessArray.append(businessName)
                                print(self.businessArray)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
