//
//  Login&SignInViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 21.04.2022.
//

import Foundation
import Firebase
import SwiftUI

class LoginAndSignInViewModel : ObservableObject {
    
    @Published var email=""
    @Published var password=""
    @Published var reEnterPassword=""
    @Published var isVerify=false
    @Published var businessName=""
    @Published var ownerName=""
    @Published var firstName=""
    @Published var lastName=""
    @Published var showAlert=false
    @Published var alertMessage=""
    @Published var alertTitle=""
    @Published var newEmail=""
    @Published var newEmail2=""
    @Published var newPassword=""
    @Published var newPassword2=""
    @Published var sendResetPassword=""
    @Published var sendVerify=false
    @Published var isLoading=false
    @Published var showHome=false
    @Published var userEmailArray=[String]()
    @Published var businessEmailArray=[String]()
    @Published var showBusinessLocation=false
    @Published var businessTown=""
    @Published var businessCity=""
    @Published var businessAddress=""
    
    
    var currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    func login(){
        
        if email != "" && password != "" {
            
            withAnimation{
                self.isLoading.toggle()
            }
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (result,error) in
                
                withAnimation{
                    self.isLoading.toggle()
                }
                
                if error != nil {
                    //türkçe uyarı ver

                    self.alertTitle = "Hata!"
                    self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                    self.showAlert.toggle()
                    
                } else {
                    self.firestoreDatabase.collection("Users").addSnapshotListener { snapshot, error in
                        if error != nil {
                            self.alertTitle="Hata!"
                            self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                            self.showAlert.toggle()
                        } else {
                            for document in snapshot!.documents {
                                if let userEmail=document.get("Email") as? String {
                                    self.userEmailArray.append(userEmail)
                                }
                            }
                            if self.userEmailArray.contains(self.email) {
                                /*
                                 if self.currentUser?.isEmailVerified == false {
                                     
                                     self.alertTitle = "Hata!"
                                     self.alertMessage = "Giriş yapabilmek için lütfen email adresinizi doğrulayınız."
                                     self.showAlert.toggle()
                                     
                                     try! Auth.auth().signOut()
                                     
                                 } else {
                                     self.showHome.toggle()
                                 }
                                 */
                                
                                self.showHome.toggle()
                            }
                            else {
                               self.alertTitle="Hata!"
                               self.alertMessage=error?.localizedDescription ?? "Email adresinizi kontrol ediniz."
                               try! Auth.auth().signOut()
                               self.showAlert.toggle()
                           }
                        }
                    }
                }
            }
            
            
        } else {
            self.alertTitle = "Hata!"
            self.alertMessage = "Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        }
    }
    
    func signIn(){
        if email != "" && password != "" && reEnterPassword != "" && firstName != "" && lastName != "" {
            
            if password==reEnterPassword {
                
                withAnimation{
                    self.isLoading.toggle()
                }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    withAnimation{
                        self.isLoading.toggle()
                    }
                    
                    if error != nil {
                        
                        self.alertTitle = "Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                        
                    } else {
                       
                        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                           "Email":Auth.auth().currentUser!.email!,
                                           "Name":self.firstName,
                                           "Surname":self.lastName,
                                           "DateofBirth":"",
                                           "City":"",
                                           "Town":"",
                                           "Phone":"",
                                           "Type":"User",
                                           "Date":FieldValue.serverTimestamp()] as [String:Any]
                        
                        self.firestoreDatabase.collection("Users").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { error2 in
                            if error2 != nil {
                                self.alertTitle="Hata!"
                                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                                self.showAlert.toggle()
                            } else {
                                 result?.user.sendEmailVerification(completion: { (err) in
                                     if err != nil{
                                         self.alertTitle="Hata!"
                                         self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                                         self.showAlert.toggle()
                                     } else {
                                         self.alertTitle="Başarılı!"
                                         self.alertMessage="Üyelik oluşturuldu e-posta adresinize mail gönderildi."
                                         self.showAlert.toggle()
                                         
                                         try! Auth.auth().signOut()
                                     }
                                 })
                            }
                        }
                        
                    }
                }
            } else {
                self.alertTitle = "Hata!"
                self.alertMessage = "Şifreler eşleşmiyor."
                self.showAlert.toggle()
            }
        } else {
            self.alertTitle = "Hata!"
            self.alertMessage = "Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        }
    }
    
    func forgotBusinessPassword(){
        
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
                }
                if self.businessEmailArray.contains(self.sendResetPassword) {
                    Auth.auth().sendPasswordReset(withEmail: self.sendResetPassword) { error in
                        if error != nil {
                            self.alertTitle="Hata!"
                            self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            self.showAlert.toggle()
                        } else {
                            self.alertTitle="Başarılı!"
                            self.alertMessage="E-posta adresinize şifrenizi resetlemek için link yollanmıştır."
                            self.showAlert.toggle()
                        }
                    }
                } else {
                    self.alertTitle="Hata!"
                    self.alertMessage=error?.localizedDescription ?? "Email adresini kontrol ediniz."
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func forgotUserPassword(){
        
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
                }
                if self.userEmailArray.contains(self.sendResetPassword) {
                    Auth.auth().sendPasswordReset(withEmail: self.sendResetPassword) { error in
                        if error != nil {
                            self.alertTitle="Hata!"
                            self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                            self.showAlert.toggle()
                        } else {
                            self.alertTitle="Başarılı!"
                            self.alertMessage="E-posta adresinize şifrenizi resetlemek için link yollanmıştır."
                            self.showAlert.toggle()
                        }
                    }
                } else {
                    self.alertTitle="Hata!"
                    self.alertMessage=error?.localizedDescription ?? "Email adresini kontrol ediniz."
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func changePassword(){
        
        if newPassword != "" && newPassword2 != "" {
            if newPassword==newPassword2 {
                currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    if error != nil {
                        self.alertTitle="Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                    } else {
                        self.alertTitle="Başarılı!"
                        self.alertMessage="Şifreniz değiştirilmiştir."
                        self.showAlert.toggle()
                    }
                })
            } else {
                self.alertTitle="Hata!"
                self.alertMessage="Şifreler eşleşmiyor."
                self.showAlert.toggle()
            }
        }else {
            self.alertTitle="Hata!"
            self.alertMessage="Lütfen eksiksiz doldurunuz."
            self.showAlert.toggle()
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            self.showHome.toggle()
        } catch {
            //hata
        }
    }
    
    func changeEmailForUser(){
        
        if newEmail != "" && newEmail2 != "" {
            if newEmail != newEmail2 {
                self.alertTitle="Hata"
                self.alertMessage="E-posta adresleriniz eşleşmiyor."
                self.showAlert.toggle()
            } else {
                currentUser?.updateEmail(to: newEmail, completion: { (error) in
                    if error != nil {
                        self.alertTitle="Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                    } else {
                        self.alertTitle="Başarılı!"
                        self.alertMessage="E-posta adresiniz değiştirilmiştir."
                        self.showAlert.toggle()
                        
                        self.firestoreDatabase.collection("Users").document(self.currentUser!.uid).updateData(["Email":self.newEmail])
                    }
                })
            }
        }else {
            self.alertTitle="Hata"
            self.alertMessage="Lütfen yeni e-posta adresini giriniz."
            self.showAlert.toggle()
        }
    }
    
    func changeEmailForBusiness(){
        
        if newEmail != "" && newEmail2 != "" {
            if newEmail != newEmail2 {
                self.alertTitle="Hata"
                self.alertMessage="E-posta adresleriniz eşleşmiyor."
                self.showAlert.toggle()
            } else {
                currentUser?.updateEmail(to: newEmail, completion: { (error) in
                    if error != nil {
                        self.alertTitle="Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                    } else {
                        self.alertTitle="Başarılı!"
                        self.alertMessage="E-posta adresiniz değiştirilmiştir."
                        self.showAlert.toggle()
                        
                        self.firestoreDatabase.collection("Business").document(self.currentUser!.uid).updateData(["Email":self.newEmail])
                    }
                })
            }
        }else {
            self.alertTitle="Hata"
            self.alertMessage="Lütfen yeni e-posta adresini giriniz."
            self.showAlert.toggle()
        }
    }
    
    func verifyEmail(){
        
        let alert = UIAlertController(title: "E-posta Doğrulama", message: "E-posta adresinizi doğrulamanız için link gönderilecektir.", preferredStyle: .alert)
        alert.addTextField{ (password) in
            password.placeholder = "E-posta"
        }
        let proceed=UIAlertAction(title: "Gönder", style: .default) { (_) in
            
            self.email=alert.textFields![0].text!
            self.sendVerify.toggle()
            //reset password
            
            /*
             
             app storea attıktan sonra link oluşturup yap.
             
             let actionCodeSettings = ActionCodeSettings()
             actionCodeSettings.url = URL(string: "example.link")
             // The sign-in operation has to always be completed in the app.
             actionCodeSettings.handleCodeInApp = true
             actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
             
             Auth.auth().sendSignInLink(toEmail: self.email, actionCodeSettings: actionCodeSettings) { error in
                 if error != nil {
                     print("hataaaaaa")
                 } else {
                     print("gönderildiiiiiiii")
                 }
             }
             */
        }
        
        let cancel = UIAlertAction(title: "İptal", style: .destructive, handler: nil)
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
        
    }
    
    func signInForBusiness(){
        if email != "" && password != "" && reEnterPassword != "" && businessName != "" && ownerName != "" {
            
            if password==reEnterPassword {
                
                withAnimation{
                    self.isLoading.toggle()
                }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    withAnimation{
                        self.isLoading.toggle()
                    }
                    
                    if error != nil {
                        
                        self.alertTitle = "Hata!"
                        self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                        self.showAlert.toggle()
                        
                    } else {
                       
                        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                           "Email":Auth.auth().currentUser!.email!,
                                           "Owner's Name":self.ownerName,
                                           "Place Name":self.businessName,
                                           "City":"",
                                           "Town":"",
                                           "Phone":"",
                                           "Village":"",
                                           "Street":"",
                                           "ImageUrl":"",
                                           "Address":"",
                                           "Type":"Business",
                                           "Date":FieldValue.serverTimestamp()] as [String:Any]
                        
                        self.firestoreDatabase.collection("Business").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { error2 in
                            if error2 != nil {
                                self.alertTitle="Hata!"
                                self.alertMessage=error2?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                                self.showAlert.toggle()
                            } else {
                                 result?.user.sendEmailVerification(completion: { (err) in
                                     if err != nil{
                                         self.alertTitle="Hata!"
                                         self.alertMessage=error2?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                                         self.showAlert.toggle()
                                     } else {
                                         /*
                                          self.alertTitle="Başarılı!"
                                          self.alertMessage="Üyelik oluşturuldu e-posta adresinize mail gönderildi."
                                          self.showAlert.toggle()
                                          */
                                         
                                         self.showBusinessLocation.toggle()
                                     }
                                 })
                            }
                        }
                        
                    }
                }
            } else {
                self.alertTitle = "Hata!"
                self.alertMessage = "Şifreler eşleşmiyor."
                self.showAlert.toggle()
            }
        } else {
            self.alertTitle = "Hata!"
            self.alertMessage = "Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        }
    }
    
    func loginForBusiness(){
        
        if email != "" && password != "" {
            
            withAnimation{
                self.isLoading.toggle()
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
                
                withAnimation{
                    self.isLoading.toggle()
                }
                
                if error != nil {
                    //türkçe uyarı ver
                    self.alertTitle = "Hata!"
                    self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                    self.showAlert.toggle()
                    
                } else {
                    
                    self.firestoreDatabase.collection("Business").addSnapshotListener { snapshot, error in
                        if error != nil {
                            self.alertTitle="Hata!"
                            self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                            self.showAlert.toggle()
                        } else {
                            for document in snapshot!.documents {
                                if let userEmail=document.get("Email") as? String {
                                    self.businessEmailArray.append(userEmail)
                                }
                            }
                            if self.businessEmailArray.contains(self.email) {
                                /*
                                 if self.currentUser?.isEmailVerified == false {
                                     
                                     self.alertTitle = "Hata!"
                                     self.alertMessage = "Giriş yapabilmek için lütfen email adresinizi doğrulayınız."
                                     self.showAlert.toggle()
                                     
                                     try! Auth.auth().signOut()
                                     
                                 } else {
                                     self.showHome.toggle()
                                 }
                                 */
                                
                                self.showHome.toggle()
                            } else {
                                self.alertTitle="Hata!"
                                self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                                try! Auth.auth().signOut()
                                self.showAlert.toggle()
                            }
                        }
                    }
                }
            }
        } else {
            self.alertTitle = "Hata!"
            self.alertMessage = "Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        }
    }

    func businessAddressInfo(){
        
        if businessTown != "" && businessCity != "" && businessAddress != "" {
            firestoreDatabase.collection("Business").document(Auth.auth().currentUser!.uid).updateData(["City":businessCity,"Town":businessTown,"Address":businessAddress]) { error in
                if error != nil {
                    self.alertTitle="Hata"
                    self.alertMessage=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                } else {
                    //try! Auth.auth().signOut()
                    self.showHome.toggle()
                }
            }
        } else {
            self.alertTitle="Hata"
            self.alertMessage="Lütfen tüm bilgileri giriniz."
            self.showAlert.toggle()
        }
    }
    
}
