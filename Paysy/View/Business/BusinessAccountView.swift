//
//  BusinessAccountView.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//


import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct BusinessAccountView: View {
    
    init() {
        let NavBarAppearance = UINavigationBarAppearance()
        NavBarAppearance.configureWithOpaqueBackground()
        NavBarAppearance.backgroundColor = .purple
        NavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        NavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
        UINavigationBar.appearance().standardAppearance = NavBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = NavBarAppearance
        
        //let TabBarAppearance = UITabBar.appearance()
        //TabBarAppearance.barTintColor = .blue
        //TabBarAppearance.scrollEdgeAppearance = UITabBarAppearance()
        //TabBarAppearance.standardAppearance = UITabBarAppearance()
        //TabBarAppearance.isHidden=false
        }
    
    @State var selected=1
    @State var showAddPhoto=false
    @State var isShowPhotoLibrary=false
    @State var isShowCamera=false
    @State var image:UIImage?
    @State var showProfile=false
    @State var show=false
    @State var dark = false
    @State var showMenu = false
    
    @StateObject var businessInfo=BusinessInformationsViewModel()
    @StateObject var businessPhoto=BusinessPhotoViewModel()
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader {_ in
                VStack {
                    TabView {
                        NavigationView {
                            VStack{
                                if image != nil {
                                    Image(uiImage: image!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.3)
                                } else if businessPhoto.profilPhoto != "" {
                                    AnimatedImage(url: URL(string: businessPhoto.profilPhoto))
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.3)
                                } else if businessPhoto.profilPhoto == "" {
                                    Button(action: {
                                        showAddPhoto.toggle()
                                    }) {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.3)
                                    }
                                }
                                HStack{
                                    NavigationLink("Fotoğraflar") {
                                        BusinessPhotosView(placeName:businessInfo.placeName)
                                    }
                                    Spacer()
                                    Button(action: {
                                        selected=1
                                    }) {
                                        Text("Bilgiler")
                                    }
                                    Spacer()
                                    Button(action: {
                                        selected=2
                                    }) {
                                        Text("Yorumlar")
                                    }
                                }
                                .padding()
                                VStack{
                                    if selected == 1 {
                                        BusinessInformationsView()
                                    } else {
                                        BusinessCommentsView(placeName:businessInfo.placeName)
                                    }
                                }
                                Spacer()
                                    .navigationTitle(businessInfo.placeName).navigationBarTitleDisplayMode(.inline)
                                    .navigationBarItems(leading:
                                                            Button(action: {
                                        withAnimation(.default){
                                            showMenu.toggle()
                                        }
                                    }) {
                                        Image(systemName: "person.circle")
                                            .foregroundColor(.white)
                                    })
                                    .navigationBarItems(leading:
                                                            Button(action: {
                                        if image != nil {
                                            image=nil
                                        }
                                        }){
                                            if image != nil {
                                                Image(systemName: "xmark").resizable().frame(width: 25, height: 25).foregroundColor(Color.white)
                                            }
                                        }
                                    )
                                
                                    .navigationBarItems(trailing:
                                                            Button(action: {
                                        if businessPhoto.profilPhoto == "" && image == nil {
                                            showAddPhoto.toggle()
                                        } else if image != nil {
                                            businessPhoto.uploadProfilePhoto(selectPhoto: image!)
                                        } else if businessPhoto.profilPhoto != "" {
                                            businessPhoto.trashClicked()
                                        }
                                    }){
                                        if image != nil {
                                            Image(systemName: "checkmark").resizable().frame(width: 25, height: 25).foregroundColor(Color.white)
                                        } else if businessPhoto.profilPhoto == "" && image == nil {
                                            Image(systemName: "plus").resizable().frame(width: 25, height: 25).foregroundColor(Color.white)
                                        } else if businessPhoto.profilPhoto != "" {
                                            Image(systemName: "trash").resizable().frame(width: 25, height: 25).foregroundColor(Color.white)
                                        }
                                    })
                            }
                        }
                        .alert(isPresented: $businessPhoto.showingAlert, content: {
                            Alert(title: Text(businessPhoto.titleInput), message: Text(businessPhoto.messageInput), dismissButton: .default(Text("Tamam")))
                        })
                        .actionSheet(isPresented: $showAddPhoto){
                            ActionSheet(title: Text("Fotoğraf Yükle"),
                                        buttons: [
                                            .default(Text("Kamera")) {
                                                isShowCamera.toggle()
                                            },
                                            .default(Text("Galeri")) {
                                                isShowPhotoLibrary.toggle()
                                            },
                                            .destructive(Text("İptal")) {
                                                
                                            },
                                        ])
                        }
                        .sheet(isPresented: $isShowPhotoLibrary) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                        }.sheet(isPresented: $isShowCamera) {
                            ImagePicker(sourceType: .camera, selectedImage: $image)
                        }
                        .fullScreenCover(isPresented: $businessPhoto.showProfile, content: {
                            BusinessAccountView()
                        })
                        .tabItem {
                            Image(systemName: "house.fill")
                        }
                        .tag(0)
                        BusinessSettingsView().tabItem {
                            Image(systemName: "gearshape")
                        }
                    }
                    .onAppear{
                        businessInfo.getInfos()
                        businessPhoto.getProfilePhoto()
                    }
                }

                HStack {
                    BusinessProfileMenu(dark: $dark, show: $showMenu)
                        .preferredColorScheme(dark ? .dark : .light)
                        .offset(x: showMenu ? 0 : -UIScreen.main.bounds.width / 1.4)
                    Spacer(minLength: 0)
                }.background(Color.primary.opacity(showMenu ? (dark ? 0.05 : 0.25):0).edgesIgnoringSafeArea(.all))
            }
        }
}
    
}

struct BusinessAccountView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessAccountView()
    }
}

struct BusinessProfileMenu : View {
    
    @Binding var dark : Bool
    @Binding var show : Bool
    @State var showPersonalInfo = false
    @State var showLoginInfo = false
    @State var showAppInfo=false
    @State var showInvite=false
    @State var showHelp=false
    
    @StateObject var model=LoginAndSignInViewModel()
    @StateObject var businessInfo=BusinessInformationsViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    withAnimation(.default){
                        show.toggle()
                    }
                }) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width: 12, height: 20)
                }
                Spacer()
            
            }.padding(.top)
                .padding(.bottom,5)
            
            Image(systemName: "person")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            VStack(spacing: 12){
                Text(businessInfo.placeName)
                    .font(.caption)
            }
            .padding(.top,5)
            
            Group{
                Button(action: {
                    showLoginInfo.toggle()
                }) {
                    HStack(spacing:22){
                        Image(systemName: "key")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Giriş Bilgileri")
                            .fullScreenCover(isPresented: $showLoginInfo) { () -> LoginInformationView in
                                return LoginInformationView(show: $showLoginInfo)
                            }
                        Spacer()
                    }
                }
                .padding(.top,5)
                
                Button(action: {
                    showAppInfo.toggle()
                }) {
                    HStack(spacing:22){
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Uygulama Ayarları")
                            .fullScreenCover(isPresented: $showAppInfo) { () -> AppInformationView in
                                return AppInformationView(show: $showAppInfo)
                            }

                        Spacer()
                    }
                }
                .padding(.top,5)
                
                Divider()
                    .padding(.top,5)
                
                Button(action: {
                    
                }) {
                    HStack(spacing:22){
                        Image(systemName: "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Değerlendir").scaledToFill()
                        Spacer()
                    }
                }
                .padding(.top,5)
                Button(action: {
                    showHelp.toggle()
                }) {
                    HStack(spacing:22){
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Yardım")
                            .fullScreenCover(isPresented: $showHelp) { () -> HelpView in
                                return HelpView(show: $showHelp)
                            }
                        Spacer()
                    }
                }
                .padding(.top,5)
                Button(action: {
                    model.logout()
                }) {
                    HStack(spacing:22){
                        Image(systemName: "multiply.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.red)
                        Text("Çıkış Yap")
                        Spacer()
                    }
                }
                .fullScreenCover(isPresented: $model.showHome) { () -> HomeView in
                    return HomeView()
                }
                .padding(.top,5)
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
        .padding(.horizontal,20)
        .frame(width: UIScreen.main.bounds.width / 1.4,height: UIScreen.main.bounds.height * 1)
        .background((self.dark ? Color.black : Color.white))
        .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
        .onAppear{
            businessInfo.getInfos()
        }
    }
}
