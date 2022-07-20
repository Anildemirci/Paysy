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
    @Published var userEmailArray=[String]()
    @Published var favCheck=false
    @Published var userFavPlaces=[String]()
    @Published var userIDArray=[String]()
    @Published var profilePhoto=""
    @Published var showHome=false
    @Published var placeModels = [placeModel]()
    
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    func updateInfo(){
        firestoreDatabase.collection("Users").document(currentUser!.uid).updateData(["Phone":phoneNumber,
                                                                                        "DateofBirth":birthDay,
                                                                                        "City":city,
                                                                                        "Town":town
                                                                                    ]) { error in
            if error == nil {
                self.alertTitle="Başarılı"
                self.alertMessage="Bilgiler güncellenmiştir."
                self.showAlert.toggle()
            }
        }
    }
    
    func getInfos(){
        firestoreDatabase.collection("Users").document(currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error != nil {
                
                
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
                if let favPlaces=snapshot?.get("FavoritePlaces") as? [String]{
                    self.userFavPlaces=favPlaces
                }
                
                for i in self.userFavPlaces {
                    self.placeModels.removeAll(keepingCapacity: false)
                    self.firestoreDatabase.collection("ProfilePhoto").whereField("Place Name", isEqualTo: i).addSnapshotListener { (snapshot, error) in
                            if error == nil {
                                
                                for document in snapshot!.documents{
                                    let placePhoto=document.get("imageUrl") as? String
                                    let placeName=document.get("Place Name") as? String

                                    self.placeModels.append(placeModel(name: placeName ?? "", imageUrl: placePhoto ?? ""))
                                }
                                
                            }
                        }
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
        firestoreDatabase.collection("Users").addSnapshotListener { snapshot, error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                for document in snapshot!.documents {
                    if let userEmail=document.get("Email") as? String {
                        self.userEmailArray.append(userEmail)
                    }
                    if let userID=document.get("User") as? String {
                        self.userIDArray.append(userID)
                    }

                }
            }
        }
    }
    
    func addFavorite(placeName:String){
        self.firestoreDatabase.collection("Users").whereField("User", isEqualTo: self.currentUser?.uid).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let documentId=document.documentID
                    if var favArray=document.get("FavoritePlaces") as? [String] {
                        if favArray.contains(placeName) {
                            self.favCheck.toggle()
                        } else {
                            favArray.append(placeName)
                            let addFavPlace=["FavoritePlaces":favArray] as [String:Any]
                            self.firestoreDatabase.collection("Users").document(documentId).setData(addFavPlace, merge: true) { (error) in
                                if error == nil {
                                    self.favCheck.toggle()
                                    self.alertTitle="Başarılı"
                                    self.alertMessage="Mekan favorilerinize eklenmiştir."
                                    self.showAlert.toggle()
                                }
                            }
                        }
                    }else {
                        let addFavPlace=["FavoritePlaces":[placeName]] as [String:Any]
                        self.firestoreDatabase.collection("Users").document(documentId).setData(addFavPlace, merge: true)
                        self.favCheck.toggle()
                        self.alertTitle="Başarılı"
                        self.alertMessage="Mekan favorilerinize eklenmiştir."
                        self.showAlert.toggle()
                    }
                }
            }
        }
    }

    func delFavorite(placeName:String){
        firestoreDatabase.collection("Users").document(currentUser!.uid).updateData(["FavoritePlaces":FieldValue.arrayRemove([placeName])])
        self.favCheck.toggle()
        self.alertTitle="Başarılı"
        self.alertMessage="Mekan favorilerinizden çıkartılmıştır."
        self.showAlert.toggle()
    }
    
    
    func getProfilePhoto(){
        
        self.firestoreDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    if let imageUrl=snapshot?.get("imageUrl") as? String {
                        self.profilePhoto=imageUrl
                    }
                }
            }
        }
    
    func uploadProfilePhoto(selectPhoto : UIImage){
        
            let storage=Storage.storage()
            let storageReference=storage.reference()
            let mediaFolder=storageReference.child("Profile")
            if let data=selectPhoto.jpegData(compressionQuality: 0.75) {
                let uuid=Auth.auth().currentUser!.uid
                
                let imageReference=mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { (metadata, error) in
                    if error != nil {
                        self.alertTitle="Hata"
                        self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl=url?.absoluteString
                                
                                let firestoreProfile=["imageUrl":imageUrl!,
                                                      "ID":Auth.auth().currentUser!.uid,
                                                      "User":Auth.auth().currentUser!.email!,
                                                      "Date":FieldValue.serverTimestamp()] as [String:Any]
                                self.firestoreDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).setData(firestoreProfile) { (error) in
                                    if error != nil {
                                        self.alertTitle="Hata"
                                        self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                        self.showAlert.toggle()
                                    } else {
                                        self.alertTitle="Başarılı"
                                        self.alertMessage="Fotoğraf yüklendi."
                                        self.showHome.toggle()
                                        self.showAlert.toggle()
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    
    func trashClicked(){
        let storage=Storage.storage()
        
        self.firestoreDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).delete { error in
                if error != nil {
                    self.alertTitle="Hata"
                    self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                    self.showAlert.toggle()
                } else {
                    let storageRef=storage.reference()
                    let uuid=Auth.auth().currentUser!.uid
                    let deleteRef=storageRef.child("Profile").child("\(uuid).jpg")
                    deleteRef.delete { error in
                        if error != nil {
                            self.alertTitle="Hata"
                            self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            self.showAlert.toggle()
                        } else {
                            self.alertTitle="Başarılı"
                            self.alertMessage="Profil fotoğrafınız silinmiştir."
                            self.profilePhoto=""
                            self.showAlert.toggle()
                        }
                    }
                }
            }
        }
}
