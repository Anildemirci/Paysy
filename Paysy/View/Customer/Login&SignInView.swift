//
//  Login&SignInView.swift
//  Paysy
//
//  Created by Anıl Demirci on 13.04.2022.
//

import SwiftUI
import Firebase

struct Login_SignInView: View {
    
    @State var showLogin=false
    
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
    
    @State var shownPass=false
    @State var shownPass2=false
    @State var show=false
    var showDismissButton="0"
    
    @StateObject var signInModel=LoginAndSignInViewModel()
    
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
    
    @State var email=""
    @State var password=""
    @State var shownPass=false
    @State var show=false
    var showDismissButton="0"
    
    @StateObject var loginModel=LoginAndSignInViewModel()
    
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
                        loginModel.forgotPassword()
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
            
            if loginModel.isLoading {
                CustomLoadingView()
            }
        }
        .padding()
        
        .alert(isPresented: $loginModel.showAlert, content: {
            Alert(title: Text(loginModel.alertTitle), message: Text(loginModel.alertMessage), dismissButton: .destructive(Text("Tamam")))
        })
        
    }
}

