//
//  UserInformationsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 20.04.2022.
//

import SwiftUI
import Firebase

struct PersonalInformationView: View{
    
    @Binding var show: Bool
    
    @StateObject private var personalInfoModel=UserInformationsViewModel()
    
    var body: some View {
        VStack{
            CustomDismissButton(show: $show)
            Spacer()
            Text("Kişisel Bilgiler")
                .font(.title)
                .fontWeight(.medium)
            Group {
                HStack{
                    TextField("İsim", text: $personalInfoModel.firstName)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        .allowsHitTesting(false)
                        .background(Color.secondary)
                    Spacer()
                    TextField("Soyisim", text: $personalInfoModel.lastName)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        .allowsHitTesting(false)
                        .background(Color.secondary)
                }
                TextField("telefon numarası", text: $personalInfoModel.phoneNumber)
                    .keyboardType(.numberPad)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                TextField("doğum tarihi", text: $personalInfoModel.birthDay)
                    .keyboardType(.numbersAndPunctuation)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                HStack{
                    TextField("şehir", text: $personalInfoModel.city)
                        .autocapitalization(.words)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                    TextField("ilçe", text: $personalInfoModel.town)
                        .autocapitalization(.words)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
            }
            .background(Color.white)
            Spacer()
            Button(action: {
                personalInfoModel.updateInfo()
            }) {
                Text("Düzenle")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color("back"))
        .onAppear{
            personalInfoModel.getInfos()
        }
    }
}

struct LoginInformationView: View {
    @Binding var show: Bool
    @State private var showFaceID=false
    @State private var showFingerID=false
    
    @StateObject private var model=LoginAndSignInViewModel()
    @StateObject private var business=BusinessInformationsViewModel()
    
    var body: some View{
        VStack{
            CustomDismissButton(show: $show)
            Text("Giriş Bilgileri")
                .font(.title)
                .fontWeight(.medium)
            Spacer(minLength: 25)
            ScrollView(.vertical, showsIndicators: false){
                Section(header: Text("Email Değiştir")){
                    TextField("yeni email", text: $model.newEmail)
                        .keyboardType(.emailAddress)
                        .textCase(.lowercase)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        .background(Color.white)
                    TextField("yeni email tekrarı", text: $model.newEmail2)
                        .keyboardType(.emailAddress)
                        .textCase(.lowercase)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        .background(Color.white)
                    Button(action: {
                        if business.businessIDArray.contains(Auth.auth().currentUser!.uid) {
                            model.changeEmailForBusiness()
                        } else {
                            model.changeEmailForUser()
                        }
                    }) {
                        Text("Değiştir")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    Spacer(minLength: 15)
                }
                Section(header: Text("Şifre Değiştir")){
                    
                    SecureField("yeni şifre", text: $model.newPassword)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        .background(Color.white)
                    SecureField("yeni şifre tekrarı", text: $model.newPassword2)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                        .background(Color.white)
                    Button(action: {
                        model.changePassword()
                    }) {
                        Text("Değiştir")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    Spacer(minLength: 15)
                }
                List {
                    Section{
                        Toggle("Yüz tanıma ile giriş", isOn: $showFaceID)
                            .background(Color.white)
                        Toggle("Parmak okuyucu ile giriş", isOn: $showFingerID)
                            .background(Color.white)
                    }
                }.frame(height: UIScreen.main.bounds.height * 0.2)
                    .listStyle(.plain)
                Spacer()
            }
        }
        .padding()
        .background(Color("back"))
        .onAppear{
            business.businesses()
        }
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text(model.alertTitle), message: Text(model.alertMessage), dismissButton: .destructive(Text("Tamam")))
        })
    }
}

struct AppInformationView: View {
    @State private var language=false
    @State private var nightMode=false
    @State private var sendEmail=false
    @State private var sendNotification=false
    @State private var sendSms=false
    @State private var callPhone=false
    @Binding var show: Bool
    
    var body: some View {
        VStack{
            CustomDismissButton(show: $show)
            Text("Uygulama Ayarları")
                .font(.title)
                .fontWeight(.medium)
            Section{
                Toggle("Gece Modu", isOn: $nightMode)
                    .frame(height: UIScreen.main.bounds.height * 0.070)
                    .background(Color.white)
                Toggle("English", isOn: $language)
                    .frame(height: UIScreen.main.bounds.height * 0.070)
                    .background(Color.white)
               
            }
            List {
                Section(header: Text("İletişim Tercihleri")){
                    Toggle("E-posta", isOn: $sendEmail)
                        .background(Color.white)
                    Toggle("Bildirim", isOn: $sendNotification)
                        .background(Color.white)
                    Toggle("SMS", isOn: $sendSms)
                        .background(Color.white)
                    Toggle("Telefon", isOn: $callPhone)
                        .background(Color.white)
                }
            }.frame(height: UIScreen.main.bounds.height * 0.4)
                .listStyle(.plain)
            Spacer()
        }
        .padding()
        .background(Color("back"))
    }
}

struct InviteSomeoneView: View {
    @Binding var show: Bool
    
    var body: some View {
        CustomDismissButton(show: $show)
        VStack(spacing:20){
            Text("Davet Et")
                .font(.title)
                .fontWeight(.medium)
            Text("Arkadaşlarını davet et karşılığında ödüller kazan.")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            VStack{
                Text("Referans Kodun: Anil12345")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }.padding()
                .background(Color.white)
            List{
                Section(header: Text("Referans oldukların")
                    .foregroundColor(Color.black)) {
                    Text("Anil demirci")
                    Text("Anil demirci")
                    Text("Anil demirci")
                    Text("Anil demirci")
                }
            }.listStyle(.plain)
            Spacer()
        }
        .padding()
        .background(Color("back"))
    }
}

struct HelpView: View {
    @Binding var show: Bool
    
    var body: some View {
        if show==true {
            NavigationView {
                VStack {
                    CustomDismissButton(show: $show)
                    Text("Yardım")
                        .font(.title)
                        .fontWeight(.medium)
                    List{
                        NavigationLink("Hakkımızda") {
                            AbousUsView()
                        }
                        NavigationLink("Kullanıcı Sözleşmesi ve KVK") {
                            AbousUsView()
                        }
                        NavigationLink("Aydınlatma Metni") {
                            AbousUsView()
                        }
                        NavigationLink("SSS") {
                            AbousUsView()
                        }
                        NavigationLink("Bize Ulaşın") {
                            AbousUsView()
                        }
                    }.listStyle(.plain)
                }
                .background(Color("back"))
                .navigationBarHidden(true)
            }
        }
    }
}

struct AbousUsView: View {
    var body: some View{
        VStack{
            Text("Hakkımızda")
                .navigationBarTitleDisplayMode(.inline)
                //.navigationBarHidden(true)
        }
    }
}

