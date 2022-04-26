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
    @Published var firstName=""
    @Published var lastName=""
    @Published var showAlert=false
    @Published var alertMessage=""
    @Published var alertTitle=""
    @Published var newEmail=""
    @Published var newEmail2=""
    @Published var newPassword=""
    @Published var newPassword2=""
    @Published var sendResetPassword=false
    @Published var sendVerify=false
    @Published var isLoading=false
    @Published var showHome=false
    
    let currentUser=Auth.auth().currentUser
    let firestoreDatabase=Firestore.firestore()
    
    func login(){
        
        if email != "" && password != "" {
            
            withAnimation{
                self.isLoading.toggle()
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (result,error) in
                
                withAnimation{
                    self.isLoading.toggle()
                }
                
                if error != nil {
                    // database'den kontrol ettir sonra giriş yaptır.
                    self.alertTitle = "Hata!"
                    self.alertMessage=error?.localizedDescription ?? "Sunucu hatası tekrar deneyiniz."
                    self.showAlert.toggle()
                    
                } else {
                    
                    if self.currentUser?.isEmailVerified == false {
                        
                        self.alertTitle = "Hata!"
                        self.alertMessage = "Giriş yapabilmek için lütfen email adresinizi doğrulayınız."
                        self.showAlert.toggle()
                        
                        try! Auth.auth().signOut()
                        
                    } else {
                        self.showHome.toggle()
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
                        
                        self.firestoreDatabase.collection("Users").document(self.currentUser!.uid).setData(firestoreUser) { error2 in
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
    
    func forgotPassword(){
        
        //custom alert
        let alert = UIAlertController(title: "Şifre sıfırlama", message: "Şifrenizi sıfırlamamız için e-posta adresinizi giriniz.", preferredStyle: .alert)
        alert.addTextField{ (password) in
            password.placeholder = "E-posta"
        }
        let proceed=UIAlertAction(title: "Reset", style: .default) { (_) in
            self.email=alert.textFields![0].text!
            self.sendResetPassword.toggle()
            //reset password
            Auth.auth().sendPasswordReset(withEmail: self.email) { error in
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
        }
        
        let cancel = UIAlertAction(title: "İptal", style: .destructive, handler: nil)
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert,animated: true)
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
    
    func changeEmail(){
        let oldmail=currentUser?.email
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
                        
                        self.firestoreDatabase.collection("Users").document(oldmail!).updateData(["Email":self.newEmail])
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
}
