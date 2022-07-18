//
//  Login&SignInView.swift
//  Paysy
//
//  Created by Anıl Demirci on 13.04.2022.
//

import SwiftUI
import Firebase

struct Login_SignInView: View {
    
    @State private var showLogin=false
    
    var body: some View {
        
        ScrollView(.vertical,showsIndicators: false) {
            VStack{
                if showLogin == false {
                    SignIn()
                } else {
                    Login()
                }
                HStack{
                    Text(showLogin ? "Üyelik Oluştur" : "Zaten hesabın var mı?")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Button(action:{
                        withAnimation{
                            showLogin.toggle()
                        }
                    }, label: {
                        Text(showLogin ? "Üye Ol" : "Giriş Yap")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                    })
                }.padding(.bottom,10)
                Spacer()
            }
        }
    }
}

struct Login_SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Login_SignInView()
    }
}

struct SignIn: View {
    
    @State private var shownPass=false
    @State private var shownPass2=false
    @State private var show=false
    var showDismissButton="0"
    
    @StateObject private var signInModel=LoginAndSignInViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack{
                VStack{
                    if showDismissButton == "1" {
                        HStack{
                            Spacer()
                            Button(action: {
                                show.toggle()
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .padding()
                                    
                            }
                            .fullScreenCover(isPresented: $show) { () -> CustomerHomeView in
                                CustomerHomeView()
                            }
                        }.frame(height: 25)
                    }
                    Group{
                        Text("ÜYE OL")
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(1.9) //letter spacing
                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                        TextField("İsim", text: $signInModel.firstName)
                                .font(.system(size: 20,weight: .semibold))
                                .autocapitalization(.words)
                        Divider()
                        TextField("Soyisim", text: $signInModel.lastName)
                                .font(.system(size: 20,weight: .semibold))
                                .autocapitalization(.words)
                        Divider()
                        TextField("E-mail adresi", text: $signInModel.email)
                                .font(.system(size: 20,weight: .semibold))
                                .autocapitalization(.none)
                                .textCase(.lowercase)
                                .keyboardType(.emailAddress)
                        Divider()
                    }
                    .foregroundColor(.black)
                    .padding(.top,10)
                    Group{
                        VStack {
                            HStack{
                                if shownPass == false {
                                    SecureField("Şifre",text: $signInModel.password)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass.toggle()
                                    }) {
                                        Image(systemName: "eye.circle.fill")
                                    }
                                } else {
                                    TextField("Şifre", text: $signInModel.password)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass.toggle()
                                    }) {
                                        Image(systemName: "eye.slash.circle.fill")
                                    }
                                }
                            }
                        }
                        Divider()
                        VStack {
                            HStack{
                                if shownPass2 == false {
                                    SecureField("Şifre tekrarı",text: $signInModel.reEnterPassword)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass2.toggle()
                                    }) {
                                        Image(systemName: "eye.circle.fill")
                                    }
                                } else {
                                    TextField("Şifre tekrarı", text: $signInModel.reEnterPassword)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass2.toggle()
                                    }) {
                                        Image(systemName: "eye.slash.circle.fill")
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    .foregroundColor(.black)
                    .padding(.top,10)
                    Spacer()
                    Group{
                        HStack{
                            Image(systemName: "person")
                            Text("Kullanım sözleşmesini okudum ve onaylıyorum.")
                        }
                        HStack{
                            Image(systemName: "person")
                            Text("Kişisel verilerimin, Aydınlatma Metni kapmasında işlenmesine ve aktarılmasına açık rıza veriyorum.")
                        }
                        HStack{
                            Image(systemName: "person")
                            Text("Restoran indirimleri ve kampanyalardan haberdar olmak istiyorum.")
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.height * 0.055)
                    .font(.footnote)
                    Spacer()
                    Button(action: {
                        signInModel.signIn()
                    }, label: {
                        Text("Üye Ol")
                            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.075)
                            .foregroundColor(.yellow)
                            .padding()
                            .background(Color.black)
                            .clipShape(Capsule())
                            .shadow(color: Color.red.opacity(0.6), radius: 5, x: 0, y: 0)
                        
                    })
                }
                if signInModel.isLoading {
                    CustomLoadingView()
                }
            }
            .padding()
            
            .alert(isPresented: $signInModel.showAlert, content: {
                Alert(title: Text(signInModel.alertTitle), message: Text(signInModel.alertMessage), dismissButton: .destructive(Text("Tamam")))
        })
        }
    }
}

struct Login: View {
    
    @State private var showTFAlert=false
    @State private var showAlert=false
    @State private var shownPass=false
    @State private var show=false
    var showDismissButton="0"
    
    @StateObject private var loginModel=LoginAndSignInViewModel()
    @StateObject private var userInfo=UserInformationsViewModel()
    
    var body: some View {
        
        ZStack{
            VStack{
                if showDismissButton == "1" {
                    HStack{
                        Spacer()
                        Button(action: {
                            show.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(Circle())
                                .padding()
                        }
                        .fullScreenCover(isPresented: $show) { () -> CustomerHomeView in
                            CustomerHomeView()
                        }
                    }.frame(height: 25)
                }
                Spacer()
                Text("Giriş Yap")
                    .font(.title)
                    .fontWeight(.bold)
                    .kerning(1.9) //letter spacing
                    .frame(maxWidth: .infinity,alignment: .leading)
                TextField("E-mail adresi", text: $loginModel.email)
                    .font(.system(size: 20,weight: .semibold))
                    .textCase(.lowercase)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .foregroundColor(.black)
                    .padding(.top,10)
            Divider()
                HStack{
                    if shownPass == false {
                        SecureField("Şifre",text: $loginModel.password)
                            .font(.system(size: 20,weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top,10)
                        Button(action: {
                            shownPass.toggle()
                        }) {
                            Image(systemName: "eye.circle.fill")
                                .foregroundColor(.black)
                                .padding(.top,10)
                        }
                    } else {
                        TextField("Şifre", text: $loginModel.password)
                            .font(.system(size: 20,weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top,10)
                        Button(action: {
                            shownPass.toggle()
                        }) {
                            Image(systemName: "eye.slash.circle.fill")
                                .foregroundColor(.black)
                                .padding(.top,10)
                        }
                    }
                }
                Divider()
                Group{
                    Button(action: {
                        showTFAlert.toggle()
                    }, label: {
                        Text("Şifremi unuttum?")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                    
                    Button(action: {
                        loginModel.verifyEmail()
                    }, label: {
                        Text("E-posta doğrulama?")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                }.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top,10)
                Spacer()
                Button(action: {
                    loginModel.login()
                }, label: {
                    Text("Giriş Yap")
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.075)
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color.black)
                        .clipShape(Capsule())
                        .shadow(color: Color.red.opacity(0.6), radius: 5, x: 0, y: 0)
                    
                })
                .fullScreenCover(isPresented: $loginModel.showHome) { () -> CustomerHomeView in
                    return CustomerHomeView()
                }
            }
            .padding()
            
            .alert(isPresented: $loginModel.showAlert, content: {
                Alert(title: Text(loginModel.alertTitle), message: Text(loginModel.alertMessage), dismissButton: .destructive(Text("Tamam")))
            })
            
            CustomAlertTFView(isShown:$showTFAlert, text: $loginModel.sendResetPassword, title: "Şifre Sıfırlama", buttonName: "Gönder", hint: "email") { resPass in
                loginModel.forgotUserPassword()
            }
            
            if loginModel.isLoading {
                CustomLoadingView()
            }
        }
    }
}

struct SignInForBusiness: View {
    
    @State private var shownPass=false
    @State private var shownPass2=false
    @State private var show=false
    @StateObject private var signInModel=LoginAndSignInViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack{
                VStack{
                    HStack{
                        Spacer()
                        Button(action: {
                            show.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(Circle())
                                .padding()
                                
                        }
                        .fullScreenCover(isPresented: $show) { () -> HomeView in
                            HomeView()
                        }
                    }.frame(height: 25)
                    Group{
                        Text("ÜYE OL")
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(1.9) //letter spacing
                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                        TextField("Şirket İsmi", text: $signInModel.businessName)
                                .font(.system(size: 20,weight: .semibold))
                                .autocapitalization(.words)
                                .textCase(.uppercase)
                        Divider()
                        TextField("İsim Soyisim", text: $signInModel.ownerName)
                                .font(.system(size: 20,weight: .semibold))
                                .autocapitalization(.words)
                        Divider()
                        TextField("E-mail adresi", text: $signInModel.email)
                                .font(.system(size: 20,weight: .semibold))
                                .autocapitalization(.none)
                                .textCase(.lowercase)
                                .keyboardType(.emailAddress)
                        Divider()
                    }
                    .foregroundColor(.black)
                    .padding(.top,10)
                    Group{
                        VStack {
                            HStack{
                                if shownPass == false {
                                    SecureField("Şifre",text: $signInModel.password)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass.toggle()
                                    }) {
                                        Image(systemName: "eye.circle.fill")
                                    }
                                } else {
                                    TextField("Şifre", text: $signInModel.password)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass.toggle()
                                    }) {
                                        Image(systemName: "eye.slash.circle.fill")
                                    }
                                }
                            }
                        }
                        Divider()
                        VStack {
                            HStack{
                                if shownPass2 == false {
                                    SecureField("Şifre tekrarı",text: $signInModel.reEnterPassword)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass2.toggle()
                                    }) {
                                        Image(systemName: "eye.circle.fill")
                                    }
                                } else {
                                    TextField("Şifre tekrarı", text: $signInModel.reEnterPassword)
                                        .font(.system(size: 20,weight: .semibold))
                                    Button(action: {
                                        shownPass2.toggle()
                                    }) {
                                        Image(systemName: "eye.slash.circle.fill")
                                    }
                                }
                            }
                        }
                        Divider()
                    }
                    .foregroundColor(.black)
                    .padding(.top,10)
                    Spacer()
                    Group{
                        HStack{
                            Image(systemName: "person")
                            Text("Kullanım sözleşmesini okudum ve onaylıyorum.")
                        }
                        HStack{
                            Image(systemName: "person")
                            Text("Kişisel verilerimin, Aydınlatma Metni kapmasında işlenmesine ve aktarılmasına açık rıza veriyorum.")
                        }
                        HStack{
                            Image(systemName: "person")
                            Text("Restoran indirimleri ve kampanyalardan haberdar olmak istiyorum.")
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.height * 0.055)
                    .font(.footnote)
                    Spacer()
                    Button(action: {
                        signInModel.signInForBusiness()
                    }, label: {
                        Text("Üye Ol")
                            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.075)
                            .foregroundColor(.yellow)
                            .padding()
                            .background(Color.black)
                            .clipShape(Capsule())
                            .shadow(color: Color.red.opacity(0.6), radius: 5, x: 0, y: 0)
                        
                    })
                }
                if signInModel.isLoading {
                    CustomLoadingView()
                }
            }
            .padding()
            .alert(isPresented: $signInModel.showAlert, content: {
                Alert(title: Text(signInModel.alertTitle), message: Text(signInModel.alertMessage), dismissButton: .destructive(Text("Tamam")))
        })
            .fullScreenCover(isPresented: $signInModel.showBusinessLocation) { () -> BusinessLocationInfoView in
                BusinessLocationInfoView()
            }
        }
    }
}

struct BusinessLocationInfoView: View {
    
    @StateObject private var signIn=LoginAndSignInViewModel()
    @State private var show=false
    
    var body: some View{
        VStack(spacing:10){
            TextField("İlçe", text: $signIn.businessTown)
                    .font(.system(size: 20,weight: .semibold))
                    .autocapitalization(.words)
            Divider()
            TextField("İl", text: $signIn.businessCity)
                    .font(.system(size: 20,weight: .semibold))
                    .autocapitalization(.words)
            Divider()
            TextField("Adres(isteğe bağlı)", text: $signIn.businessAddress)
                    .font(.system(size: 20,weight: .semibold))
                    .autocapitalization(.words)
            Button(action: {
                signIn.businessAddressInfo()
            }, label: {
                Text("İlerle")
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.075)
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.black)
                    .clipShape(Capsule())
                    .shadow(color: Color.red.opacity(0.6), radius: 5, x: 0, y: 0)
            })
        }.padding()
        
            .alert(isPresented: $signIn.showAlert, content: {
                Alert(title: Text(signIn.alertTitle), message: Text(signIn.alertMessage), dismissButton: .destructive(Text("Tamam")))
        })
            .fullScreenCover(isPresented: $signIn.showHome ) { () -> BusinessHomeView in
            BusinessHomeView()
        }

    }
}

struct BusinessPhoneInfoView: View {
    @StateObject private var businessInfo=BusinessInformationsViewModel()
    var body: some View{
        VStack{
            CustomPhoneTextField()
            Button(action: {
                //action
            }, label: {
                Text("Üyeliği Tamamla")
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.075)
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.black)
                    .clipShape(Capsule())
                    .shadow(color: Color.red.opacity(0.6), radius: 5, x: 0, y: 0)
            })
        }
    }
}

struct LoginForBusiness: View {
    
    @State private var shownPass=false
    @State private var show=false
    @State private var showAlertTF=false
    
    @StateObject private var loginModel=LoginAndSignInViewModel()
    @StateObject private var businessArray=BusinessInformationsViewModel()
    
    var body: some View {
        
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        show.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.black)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding()
                    }
                    .fullScreenCover(isPresented: $show) { () -> HomeView in
                        HomeView()
                    }
                }.frame(height: 25)
                Spacer()
                Text("Giriş Yap")
                    .font(.title)
                    .fontWeight(.bold)
                    .kerning(1.9) //letter spacing
                    .frame(maxWidth: .infinity,alignment: .leading)
                TextField("E-mail adresi", text: $loginModel.email)
                    .font(.system(size: 20,weight: .semibold))
                    .autocapitalization(.none)
                    .textCase(.lowercase)
                    .keyboardType(.emailAddress)
                    .foregroundColor(.black)
                    .padding(.top,10)
            Divider()
                HStack{
                    if shownPass == false {
                        SecureField("Şifre",text: $loginModel.password)
                            .font(.system(size: 20,weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top,10)
                        Button(action: {
                            shownPass.toggle()
                        }) {
                            Image(systemName: "eye.circle.fill")
                                .foregroundColor(.black)
                                .padding(.top,10)
                        }
                    } else {
                        TextField("Şifre", text: $loginModel.password)
                            .font(.system(size: 20,weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top,10)
                        Button(action: {
                            shownPass.toggle()
                        }) {
                            Image(systemName: "eye.slash.circle.fill")
                                .foregroundColor(.black)
                                .padding(.top,10)
                        }
                    }
                }
                Divider()
                Group{
                    Button(action: {
                        showAlertTF.toggle()
                    }, label: {
                        Text("Şifremi unuttum?")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                    
                    Button(action: {
                        loginModel.verifyEmail()
                    }, label: {
                        Text("E-posta doğrulama?")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    })
                }.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top,10)
                Spacer()
                Button(action: {
                    loginModel.loginForBusiness()
                }, label: {
                    Text("Giriş Yap")
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.width * 0.075)
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color.black)
                        .clipShape(Capsule())
                        .shadow(color: Color.red.opacity(0.6), radius: 5, x: 0, y: 0)
                    
                })
                .fullScreenCover(isPresented: $loginModel.showHome) { () -> BusinessAccountView in
                    return BusinessAccountView()
                }
            }
            .padding()
            
            .alert(isPresented: $loginModel.showAlert, content: {
                Alert(title: Text(loginModel.alertTitle), message: Text(loginModel.alertMessage), dismissButton: .destructive(Text("Tamam")))
            })
            
            CustomAlertTFView(isShown:$showAlertTF, text: $loginModel.sendResetPassword, title: "Şifre Sıfırlama", buttonName: "Gönder", hint: "email") { resPass in
                loginModel.forgotBusinessPassword()
            }
            
            if loginModel.isLoading {
                CustomLoadingView()
            }
        }

    }
}
