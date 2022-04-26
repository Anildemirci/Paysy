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
    
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    func updateInfo(){
        firestoreDatabase.collection("Users").document(currentUser!.email!).updateData(["Phone":phoneNumber,
                                                                                        "DateofBirth":birthDay,
                                                                                        "City":city,
                                                                                        "Town":town
                                                                                       ])
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
    
    
    
}
