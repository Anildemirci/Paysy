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
                self.alertMessage="Kaydedildi."
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
                self.alertMessage="Ürün eklendi."
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
        firestoreDatabase.collection("Menu").document(placeName).collection("All Items").getDocuments { (snapshot,error)  in
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

    func deleteItem(at indexSet: IndexSet) {
        
             indexSet.forEach { index in
                 
                 getItem(placeName: placeNameForDeleteItem)
                 let delItem=allItemsName[index]
                 firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).collection("All Items").whereField("ItemName", isEqualTo: delItem).getDocuments() { (query, error) in
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
    
    func deleteMenu(at indexSet: IndexSet) {
        
             indexSet.forEach { index in
                 let delField=categories[index]
                 firestoreDatabase.collection("Menu").document(placeNameForDeleteItem).updateData(["Categories" : FieldValue.arrayRemove([delField])])
             }
         }
}

var placeNameForDeleteItem=""
var menuNameForDelete=""
