//
//  UserInformationsViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 26.04.2022.
//

import Foundation
import Firebase

class UserInformationsViewModel : ObservableObject {
    
    @Published var firstName=""
    @Published var lastName=""
    @Published var phoneNumber=""
    @Published var birthDay=""
    @Published var city=""
    @Published var town=""
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var mailCheck=false
    @Published var notificationCheck=false
    @Published var SMSCheck=false
    @Published var phoneCheck=false
    @Published var userArray=[String]()
    
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    func updateInfo(){
        firestoreDatabase.collection("Users").document(currentUser!.uid).updateData(["Phone":phoneNumber,
                                                                                        "DateofBirth":birthDay,
                                                                                        "City":city,
                                                                                        "Town":town
                                                                                       ])
    }
    
    func getInfos(){
        firestoreDatabase.collection("Users").document(currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error != nil {
                
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
                
            } else {
                if let name = snapshot?.get("Name") as? String {
                    self.firstName=name
                }
                if let surName = snapshot?.get("Surname") as? String {
                    self.lastName=surName
                }
                if let city = snapshot?.get("City") as? String {
                    self.city=city
                }
                if let dateofBirth = snapshot?.get("DateofBirth") as? String {
                    self.birthDay=dateofBirth
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
    
    func communicationPreferences(){
        
        //fonksiyonu kullan
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "Name":self.firstName,
                           "Surname":self.lastName,
                           "Phone":"",
                           "Type":"User",
                           "MailCheck":mailCheck,
                           "NotificationCheck":notificationCheck,
                           "SMSCheck":SMSCheck,
                           "PhoneCheck":phoneCheck,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        self.firestoreDatabase.collection("UserCommunicationPreferences").document(currentUser!.uid).setData(firestoreUser) { error in
            if error != nil {
                
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
                
            } else {
                
            }
        }
    }

    //kullanıcılar arrayi
    func users(){
        firestoreDatabase.collection("Users").getDocuments { snapshot, error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                for document in snapshot!.documents {
                    if let userEmail=document.get("Email") as? String {
                        self.userArray.append(userEmail)
                    }
                }
            }
        }
    }
    //business arrayi

    
}
