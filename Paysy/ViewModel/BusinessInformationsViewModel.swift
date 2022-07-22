//
//  LocationInfoViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 18.06.2022.
//

import Foundation
import Firebase
import MapKit

class BusinessInformationsViewModel : ObservableObject {
    
    @Published var placeName=""
    @Published var placeID=""
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
    @Published var businessIDArray=[String]()
    @Published var businessEmailArray=[String]()
    @Published var annotationLongitude=Double()
    @Published var annotationLatitude=Double()
    @Published var parts=[String]()
    @Published var features=[String]()
    @Published var totalTable=""
    @Published var getTotalTable=""
    @Published var getTableName=[String]()
    @Published var openingTime=""
    @Published var closingTime=""
    @Published var placeModels=[placeModel]()
    
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
                if let closeHour = snapshot?.get("Closed") as? String {
                    self.closingTime=closeHour
                }
                if let openHour = snapshot?.get("Opened") as? String {
                    self.openingTime=openHour
                }
            }
        }
    }
    
    //business info for user
    func getInfoForUser(placeName:String){
        firestoreDatabase.collection("Business").whereField("Place Name", isEqualTo: placeName).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let address=document.get("Address") as? String {
                        self.address=address
                    }
                    
                    if let city=document.get("City") as? String {
                        self.city=city
                    }
                    
                    if let name=document.get("Name") as? String {
                        self.placeName=name
                    }
    
                    if let phonenumber=document.get("Phone") as? String {
                        self.phoneNumber=phonenumber
                    }
                    if let town=document.get("Town") as? String {
                        self.town=town
                    }
                    if let id=document.get("User") as? String {
                        self.placeID=id
                    }
                }
            }
        }
    }
    //kullanıcı için lokasyonun koordinatlarını getiriyor
    func getLocation(placeName:String){
        firestoreDatabase.collection("Business").whereField("Place Name", isEqualTo: placeName).addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let documentId=document.documentID
                    self.firestoreDatabase.collection("Locations").document(documentId).addSnapshotListener { (snapshot, error) in
                        if error == nil {
                            
                            if let longitude=snapshot?.get("Longitude") {
                                self.annotationLongitude=longitude as! Double
                            } else  {
                                self.annotationLongitude=0
                            }
                            if let latitude=snapshot?.get("Latitude") {
                                self.annotationLatitude=latitude as! Double
                            } else {
                                self.annotationLatitude=0
                            }
                        }
                    }
                }
            }
        }
    }
    //navigasyon
    func navigationClicked(placeName:String,x:Double,y:Double){
        
        if x != 0 && y != 0 {
            let requestLocation=CLLocation(latitude: x, longitude: y)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark=MKPlacemark(placemark: placemarks![0])
                        let item=MKMapItem(placemark: newPlacemark)
                        item.name=placeName
                        let launchOptions=[MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        } else {
            self.alertTitle="Hata"
            self.alertMessage="İş yeri tarafından konum bilgisi henüz kaydedilmedi."
            self.showAlert.toggle()
        }
    }
    
    //adress güncelleme
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
        firestoreDatabase.collection("Business").addSnapshotListener { snapshot, error in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                for document in snapshot!.documents {
                    if let userEmail=document.get("Email") as? String {
                        self.businessEmailArray.append(userEmail)
                    }
                    if let userID=document.get("User") as? String {
                        self.businessIDArray.append(userID)
                    }
                }
            }
        }
    }
    
    func setTables(placeName:String,city:String,town:String){
        
        if totalTable == "" && parts == nil {
            self.alertTitle="Hata!"
            self.alertMessage="Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        } else {
            let firestoreUser=["User":Auth.auth().currentUser!.uid,
                               "Email":Auth.auth().currentUser!.email!,
                               "Place Name":placeName,
                               "City":city,
                               "Town":town,
                               "Total Table":self.getTotalTable,
                               "Parts":self.parts,
                               "Date":FieldValue.serverTimestamp()] as [String:Any]
            
            self.firestoreDatabase.collection("Tables").document(placeName).setData(firestoreUser) { error in
                if error != nil {
                    self.alertTitle="Hata!"
                    self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                    self.showAlert.toggle()
                } else {
                    self.alertTitle="Başarılı!"
                    self.alertMessage="Kaydedildi."
                    self.showAlert.toggle()
                    self.parts=[String]()
                    self.totalTable=""
                }
            }
        }
    }
    
    func setPartInfo(placeName:String,partName:String){
        
        let firestoreUser=["Total Table":self.totalTable,
                           "Features":self.features,
                           "Part Name":partName,
                           "Date":FieldValue.serverTimestamp()] as [String:Any]
        
        self.firestoreDatabase.collection("Tables").document(placeName).collection("Parts").document(partName).setData(firestoreUser) { error in
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
    
    func getTables(placeName:String){
        firestoreDatabase.collection("Tables").document(placeName).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.alertTitle="Hata!"
                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                if let tableNumber = snapshot?.get("Total Table") as? String {
                    self.getTotalTable=tableNumber
                }
                if let tableNames = snapshot?.get("Parts") as? [String] {
                    self.getTableName=tableNames
                }
            }
        }
    }
    
    func businessWorkingHour(){
        if openingTime != "" && closingTime != "" {
            firestoreDatabase.collection("Business").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        let documentId=document.documentID
                        if document.get("Opened") != nil && document.get("Closed") != nil {
                            self.firestoreDatabase.collection("Business").document(documentId).updateData(["Opened":self.openingTime])
                            self.firestoreDatabase.collection("Business").document(documentId).updateData(["Closed":self.closingTime])
                            }
                        else {
                            let addOpened=["Opened":self.openingTime,
                                           "Closed":self.closingTime] as [String:Any]
                            self.firestoreDatabase.collection("Business").document(documentId).setData(addOpened, merge: true)
                            self.alertTitle="Başarılı"
                            self.alertMessage="Çalışma saatleri değiştirilmiştir."
                            self.showAlert.toggle()
                        }
                    }
                }
            }
        } else {
            self.alertTitle="Hata"
            self.alertMessage="Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        }
    }

}
