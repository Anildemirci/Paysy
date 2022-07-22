//
//  BusinessPhotosViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 22.06.2022.
//

import Combine
import Firebase
import SwiftUI

class BusinessPhotoViewModel : ObservableObject {
    
    @Published var titleInput=""
    @Published var messageInput=""
    @Published var showingAlert=false
    @Published var statement=""
    @Published var placeName=""
    @Published var show=false
    @Published var showProfile=false
    @Published var posts = [dataType]()
    @Published var storageId=[String]()
    @Published var imageUrl=[String]()
    @Published var profilPhotoArray=[String]()
    @Published var placeProilPhoto=""
    @Published var placeModels = [placeModel]()
    
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    var firebaseDatabase=Firestore.firestore()
    
    func getDataForStadium(){
      
        firebaseDatabase.collection("BusinessPhotos").document(placeName).collection("Photos").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                } else {
                    
                    self.storageId.removeAll(keepingCapacity: false)
                    self.imageUrl.removeAll(keepingCapacity: false)
                    self.posts.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documentID=document.documentID
                        let statement=document.get("Statement") as! String
                        let image=document.get("photoUrl") as! String
                        let storageID=document.get("StorageID") as! String
                        self.posts.append((dataType(id: documentID, statement: statement, image: image)))
                        self.imageUrl.append(image)
                        self.storageId.append(storageID)
                        
                    }
                    self.didChange.send(self.posts)
                }
            }
        }
    
    func uploadPhoto(selectPhoto : UIImage){
        
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("BusinessPhotos").child(placeName)
        
        if let data=selectPhoto.jpegData(compressionQuality: 0.75) {
            let uuid=UUID().uuidString

            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data,metadata: nil) { (metadata,error) in
                if error != nil {
                    self.titleInput="Hata"
                    self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                    self.showingAlert.toggle()
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                            
                            let firestorePhotos=["photoUrl": imageUrl!,
                                                 "ID": Auth.auth().currentUser!.uid,
                                                 "User": Auth.auth().currentUser!.email!,
                                                 "Date": FieldValue.serverTimestamp(),
                                                 "Statement":self.statement,
                                                 "Name":self.placeName,
                                                 "StorageID": uuid] as [String:Any]
                            Firestore.firestore().collection("BusinessPhotos").document(self.placeName).collection("Photos").addDocument(data: firestorePhotos) { (error )in
                                if error !=  nil {
                                    self.titleInput="Hata"
                                    self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    self.showingAlert.toggle()
                                    
                                } else {
                                    self.titleInput="Başarılı"
                                    self.messageInput="Fotoğraf yüklendi."
                                    self.showingAlert.toggle()
                                    self.show.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //profile fotoğrafları
    
    func getProfilePhoto(){
        
        self.firebaseDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    if let imageUrl=snapshot?.get("imageUrl") as? String {
                        self.placeProilPhoto=imageUrl
                    }
                }
            }
        }
    
    func uploadProfilePhoto(selectPhoto : UIImage, placeName: String){
        
            let storage=Storage.storage()
            let storageReference=storage.reference()
            let mediaFolder=storageReference.child("Profile")
            if let data=selectPhoto.jpegData(compressionQuality: 0.75) {
                let uuid=Auth.auth().currentUser!.uid
                
                //firebaseDatabase.collection("Business").document(Auth.auth().currentUser!.uid).setData( ["ImageUrl":imageUr], merge: true)
                
                let imageReference=mediaFolder.child("\(uuid).jpg")
                imageReference.putData(data, metadata: nil) { (metedata, error) in
                    if error != nil {
                        self.titleInput="Hata"
                        self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        self.showingAlert.toggle()
                    } else {
                        imageReference.downloadURL { (url, error) in
                            if error == nil {
                                let imageUrl=url?.absoluteString
                                
                                let pp=["ImageUrl":imageUrl!] as [String:Any]
                                
                                self.firebaseDatabase.collection("Business").document(Auth.auth().currentUser!.uid).updateData(pp)
                                
                                let firestoreProfile=["imageUrl":imageUrl!,
                                                      "ID":Auth.auth().currentUser!.uid,
                                                      "Place Name":placeName,
                                                      "User":Auth.auth().currentUser!.email!,
                                                      "Date":FieldValue.serverTimestamp()] as [String:Any]
                                self.firebaseDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).setData(firestoreProfile) { (error) in
                                    if error != nil {
                                        self.titleInput="Hata"
                                        self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                        self.showingAlert.toggle()
                                    } else {
                                        self.titleInput="Başarılı"
                                        self.messageInput="Fotoğraf yüklendi."
                                        //self.showingAlert.toggle()
                                        self.showProfile.toggle()
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
        
        self.firebaseDatabase.collection("Business").document(Auth.auth().currentUser!.uid).updateData(["ImageUrl":""]) { error in
            if error == nil {
                
            }
        }
        
        self.firebaseDatabase.collection("ProfilePhoto").document(Auth.auth().currentUser!.uid).delete { error in
                if error != nil {
                    self.titleInput="Hata"
                    self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                    self.showingAlert.toggle()
                } else {
                    let storageRef=storage.reference()
                    let uuid=Auth.auth().currentUser!.uid
                    let deleteRef=storageRef.child("Profile").child("\(uuid).jpg")
                    deleteRef.delete { error in
                        if error != nil {
                            self.titleInput="Hata"
                            self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            self.showingAlert.toggle()
                        } else {
                            self.titleInput="Başarılı"
                            self.messageInput="Profil fotoğrafınız silinmiştir."
                            self.placeProilPhoto=""
                            self.showingAlert.toggle()
                        }
                    }
                }
            }
        }
    
    func deletePhoto(at indexSet: IndexSet) {
        let storage=Storage.storage()
        
             indexSet.forEach { index in
                 
                 getDataForStadium()
                 let delPhoto=imageUrl[index]
                 let delStorage=storageId[index]
                 
                 self.firebaseDatabase.collection("BusinessPhotos").document(self.placeName).collection("Photos").whereField("photoUrl", isEqualTo: delPhoto).addSnapshotListener() { (query, error) in
                     if error == nil {
                         for document in query!.documents{
                             let delDocID=document.documentID
                             self.firebaseDatabase.collection("BusinessPhotos").document(self.placeName).collection("Photos").document(delDocID).delete(){ error in
                                 if error == nil {
                                     storage.reference().child("BusinessPhotos").child(self.placeName).child("\(delStorage).jpg").delete { error in
                                         if error != nil {
                                             self.titleInput="Hata"
                                             self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                             self.showingAlert.toggle()
                                         } else {
                                             self.titleInput="Başarılı"
                                             self.messageInput="Fotoğraf silindi."
                                             self.showingAlert.toggle()
                                         }
                                     }
                                 }else {
                                     self.titleInput="Hata"
                                     self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                     self.showingAlert.toggle()
                                 }
                             }
                         }
                     }
                 }
             }
         }
    
    
    //user tarafı
    
    func getBusinessPhotoForUser(){
        firebaseDatabase.collection("BusinessPhotos").document(placeNameFromUser).collection("Photos").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                } else {
                    
                    self.storageId.removeAll(keepingCapacity: false)
                    self.imageUrl.removeAll(keepingCapacity: false)
                    self.posts.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documentID=document.documentID
                        let statement=document.get("Statement") as! String
                        let image=document.get("photoUrl") as! String
                        let storageID=document.get("StorageID") as! String
                        self.posts.append((dataType(id: documentID, statement: statement, image: image)))
                        self.imageUrl.append(image)
                        self.storageId.append(storageID)
                        
                    }
                    self.didChange.send(self.posts)
                }
            }
    }
    
    func addMenuPhotos(selectPhoto:UIImage){
            
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("BusinessPhotos").child(placeName)
            
        if let data=selectPhoto.jpegData(compressionQuality: 0.75) {
            let uuid=UUID().uuidString
                
            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data,metadata: nil) { (metadata,error) in
                if error != nil {
                    self.titleInput="Hata"
                    self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                    self.showingAlert.toggle()
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                                
                            let firestorePhotos=["photoUrl": imageUrl!,
                                                 "ID": Auth.auth().currentUser!.uid,
                                                 "User": Auth.auth().currentUser!.email!,
                                                 "Date": FieldValue.serverTimestamp(),
                                                 "Statement":self.statement,
                                                 "Name":self.placeName,
                                                 "StorageID": uuid] as [String:Any]
                            Firestore.firestore().collection("BusinessPhotos").document(self.placeName).collection("MenuPhotos").addDocument(data: firestorePhotos) { (error )in
                                if error !=  nil {
                                    self.titleInput="Hata"
                                    self.messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    self.showingAlert.toggle()
                                    
                                } else {
                                    self.titleInput="Başarılı"
                                    self.messageInput="Fotoğraf yüklendi."
                                    self.showingAlert.toggle()
                                    self.statement=""
                                    self.show.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getBusinessMenuPhotoForUser(placeName: String){
        firebaseDatabase.collection("BusinessPhotos").document(placeName).collection("MenuPhotos").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                } else {
                    
                    self.storageId.removeAll(keepingCapacity: false)
                    self.imageUrl.removeAll(keepingCapacity: false)
                    self.posts.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documentID=document.documentID
                        let statement=document.get("Statement") as! String
                        let image=document.get("photoUrl") as! String
                        let storageID=document.get("StorageID") as! String
                        self.posts.append((dataType(id: documentID, statement: statement, image: image)))
                        self.imageUrl.append(image)
                        self.storageId.append(storageID)
                        
                    }
                    self.didChange.send(self.posts)
                }
            }
    }
    
    func getProfilePhotoForUser(placeName: String){
        
        self.firebaseDatabase.collection("ProfilePhoto").addSnapshotListener { (snapshot, error) in
                if error == nil {
                    self.placeModels.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        if placeName==document.get("Place Name") as? String {
                            if let profilPhoto=document.get("imageUrl") as? String {
                                self.placeProilPhoto=profilPhoto
                            }
                        }
                        
                        let placePhoto=document.get("imageUrl") as? String
                        let placeName=document.get("Place Name") as? String

                        self.placeModels.append(placeModel(name: placeName ?? "", imageUrl: placePhoto ?? ""))
                    }
                }
            }
        }
    
}

var placeNameFromUser=""
