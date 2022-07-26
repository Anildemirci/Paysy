//
//  MenuViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 10.07.2022.
//

import Foundation
import Firebase
import Combine

class MenuViewModel : ObservableObject {
    
    @Published var categories=[String]()
    @Published var subCategories=[String]()
    @Published var alertTitle=""
    @Published var alertMessage=""
    @Published var showAlert=false
    @Published var itemName=""
    @Published var price=""
    @Published var statement=""
    @Published var categoryName=""
    @Published var subCategoryName=""
    @Published var allItems=[menuModel]()
    @Published var allItemsName=[String]()
    @Published var editItemName=""
    
    var didChange=PassthroughSubject<Array<Any>,Never>()
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    func addMenu(placeName:String){
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "Place Name":placeName,
                           "Categories":self.categories,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("Menu").document(placeName).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Menü eklendi."
                self.showAlert.toggle()
            }
        }
    }
    
    func addSubMenu(placeName:String,menuName:String,subCategories:String) {
        let firestoreUser=["MenuType":menuName,
                           //"SubMenuType":subCategories,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        firestoreDatabase.collection("Menu").document(placeName).collection(menuName).document(subCategories).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
                
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Alt menü eklendi."
                self.showAlert.toggle()
            }
        }
    }
    
    func addItem(placeName:String, menuName:String, subCategories:String){
        
        let firestoreUser=["Price":self.price,
                           "ItemName":self.itemName,
                           "MenuType":menuName,
                           "SubMenuType":subCategories,
                           "Statement":self.statement,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("Menu").document(placeName).collection("All Items").document(self.itemName).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Ürün eklendi."
                self.showAlert.toggle()
                self.price=""
                self.itemName=""
                self.statement=""
            }
        }
    }
    
    func addPhotoItem(placeName: String,selectPhoto: UIImage,itemName:String){
        let storage=Storage.storage()
        let storageReference=storage.reference()
        let mediaFolder=storageReference.child("BusinessMenuPhotos").child(placeName)
        
        if let data=selectPhoto.jpegData(compressionQuality: 0.75) {
            let uuid=UUID().uuidString

            let imageReference=mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data,metadata: nil) { (metadata,error) in
                if error != nil {
                    self.alertTitle="Hata"
                    self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                    self.showAlert.toggle()
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl=url?.absoluteString
                            
                            Firestore.firestore().collection("Menu").document(placeName).collection("All Items").document(itemName).updateData(["imageUrl":imageUrl!]) { (error )in
                                if error !=  nil {
                                    self.alertTitle="Hata"
                                    self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    self.showAlert.toggle()
                                    
                                } else {
                                    self.alertTitle="Başarılı"
                                    self.alertMessage="Fotoğraf yüklendi."
                                    self.showAlert.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getMenu(placeName: String) {
        firestoreDatabase.collection("Menu").document(placeName).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                if let categories = snapshot?.get("Categories") as? [String] {
                    self.categories=categories
                }
            }
        }
    }
    
    func getSubMenu(placeName: String,menuName:String) {
        firestoreDatabase.collection("Menu").document(placeName).collection(menuName).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.subCategories.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    self.subCategories.append(document.documentID)
                }
                self.didChange.send(self.subCategories)
            }
        }
    }
    
    func getItem(placeName:String) {
        firestoreDatabase.collection("Menu").document(placeName).collection("All Items").addSnapshotListener { (snapshot,error)  in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                
                self.allItems.removeAll(keepingCapacity: false)
                self.allItemsName.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    let itemName=document.get("ItemName") as! String
                    let price=document.get("Price") as! String
                    let statement=document.get("Statement") as? String
                    let subMenuType=document.get("SubMenuType") as! String
                    let menuType=document.get("MenuType") as! String
                    
                    self.allItemsName.append(itemName)
                    self.allItems.append(menuModel(id: document.documentID, statement: statement ?? "", price: price, itemName: itemName, MenuType: menuType, SubMenuType: subMenuType))
                }
                self.didChange.send(self.allItems)
            }
        }
    }
    
    func getItemForEdit(placeName:String, itemName: String) {
        firestoreDatabase.collection("Menu").document(placeName).collection("All Items").whereField("ItemName", isEqualTo: itemName).getDocuments { (snapshot,error)  in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                for document in snapshot!.documents {
                    let itemName=document.get("ItemName") as! String
                    self.editItemName=itemName
                }
            
            }
        }
    }

    func deleteItem(at indexSet: IndexSet) {
        
             indexSet.forEach { index in
                 
                 getItem(placeName: placeNameForDeleteItem)
                 let delItem=allItemsName[index]
                 firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).collection("All Items").whereField("ItemName", isEqualTo: delItem).addSnapshotListener() { (query, error) in
                     if error == nil {
                         for document in query!.documents{
                             let delDocID=document.documentID
                             self.firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).collection("All Items").document(delDocID).delete(){ error in
                                 if error == nil {
                                     self.alertTitle="Başarılı"
                                     self.alertMessage="Ürün silindi."
                                     self.showAlert.toggle()
                                 }else {
                                     self.alertTitle="Hata"
                                     self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                     self.showAlert.toggle()
                                 }
                             }
                         }
                     }
                 }
             }
         }
    
    func deleteSubMenu(at indexSet: IndexSet) {
        
             indexSet.forEach { index in
                 
                 let delDoc=subCategories[index]
                 firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).collection(menuNameForDelete).document(delDoc).delete(){ error in
                     if error == nil {
                         self.alertTitle="Başarılı"
                         self.alertMessage="Alt menü silindi."
                         self.showAlert.toggle()
                     }else {
                         self.alertTitle="Hata"
                         self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                         self.showAlert.toggle()
                     }
                 }
                 
             }
         }
    
    func deleteMenu(at indexSet: IndexSet) {
        
             indexSet.forEach { index in
                 let delField=categories[index]
                 firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).updateData(["Categories" : FieldValue.arrayRemove([delField])])
             }
         }
    
    func editItem(itemName:String,newItemName:String,newPrice:String,newStatement:String,placeName:String, menuName:String, subCategories:String){
        self.firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).collection("All Items").document(itemName).delete(){ error in
            if error == nil {
                
            }else {
                
            }
        }
        
        let firestoreUser=["Price":newPrice,
                           "ItemName":newItemName,
                           "MenuType":menuName,
                           "SubMenuType":subCategories,
                           "Statement":newStatement,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        firestoreDatabase.collection("Menu").document(placeName).collection("All Items").document(newItemName).setData(firestoreUser) { error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                self.alertTitle="Başarılı!"
                self.alertMessage="Ürün güncellendi."
                self.showAlert.toggle()
                self.editItemName=""
            }
        }
    }
}

var placeNameForDeleteItem=""
var menuNameForDelete=""
