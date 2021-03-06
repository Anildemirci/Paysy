//
//  CustomerHomeView.swift
//  Paysy
//
//  Created by Anıl Demirci on 16.06.2022.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct CustomerHomeView: View {
    
    @State private var dark = false
    @State private var show = false
    //@State private var userLogin=true
    private var currentUser=Auth.auth().currentUser
   // @State var connected=false
    @StateObject private var checkUser=GetConnectionInfoViewModel()
    @State private var selection=selectionTab
    
    init() {
        let NavBarAppearance = UINavigationBarAppearance()
        NavBarAppearance.configureWithOpaqueBackground()
        NavBarAppearance.backgroundColor = UIColor(named: "logoColor")
        UINavigationBar.appearance().tintColor = .white
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
        
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader{_ in
                VStack{
                    TabView(selection: $selection) {
                        NavigationView{
                            VStack{
                                ScrollView(.vertical,showsIndicators: false) {
                                    //Spacer(minLength: 15)
                                    CampaignCell()
                                    //Spacer(minLength: 15)
                                    CategoriesCell()
                                    //Spacer(minLength: 15)
                                    PlacesCell()
                                }
                            }
                            .navigationTitle("PAYSY").navigationBarTitleDisplayMode(.inline)
                                .navigationBarItems(leading: Button(action: {
                                    withAnimation(.default){
                                        show.toggle()
                                    }
                                }) {
                                    Image(systemName: "person.circle")
                                        .foregroundColor(.white)
                                })
                                .navigationBarItems(trailing: Button(action: {
                                    
                                }) {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.white)
                                })
                                .navigationBarItems(trailing: Button(action: {
                                    
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.white)
                            })
                        }
                        .tabItem {
                            Image(systemName: "house.fill")
                        }
                        .tag(0)
                        if currentUser != nil {
                            FavoritePlacesView().tabItem {
                                Image(systemName: "star.fill")
                            }
                            .tag(1)
                        } else {
                            Login_SignInView().tabItem{
                                Image(systemName: "star.fill")
                            }.tag(2)
                        }
                        
                        if currentUser != nil {
                            if checkUser.checkUser == "" {
                                QRView().tabItem {
                                    Image(systemName: "qrcode.viewfinder")
                                }.tag(2)
                            } else {
                                ConnectToPlaceView(selectedPlace:checkUser.placeNameFromCheck, tableID: checkUser.tableIDFromCheck,tableNum: checkUser.tableNumber).tabItem {
                                    Image(systemName: "person.3")
                                }.tag(2)
                            }
                        } else {
                            HomeView().tabItem {
                                Image(systemName: "p.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }.tag(2)
                            /*
                                Login_SignInView().tabItem {
                                    Image(systemName: "qrcode.viewfinder")
                                }.tag(2)
                                */
                        }
                        TownsView().tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                        .tag(3)
                        if currentUser != nil {
                            CreditCardsView().tabItem {
                                Image(systemName: "creditcard.fill")
                            }
                            .tag(4)
                        } else {
                            Login_SignInView().tabItem {
                                Image(systemName: "creditcard.fill")
                            }
                            .tag(4)
                        }
                    }
                }.accentColor(Color("logoColor"))
                HStack {
                    if (currentUser != nil) {
                        ProfileMenu(dark: $dark, show: $show)
                            .preferredColorScheme(dark ? .dark : .light)
                            .offset(x: show ? 0 : -UIScreen.main.bounds.width / 1.4)
                        Spacer(minLength: 0)
                    } else {
                        ProfileMenuNotLogin(dark: $dark, show: $show)
                            .preferredColorScheme(dark ? .dark : .light)
                            .offset(x: show ? 0 : -UIScreen.main.bounds.width / 1.4)
                        Spacer(minLength: 0)
                    }
                }.background(Color.primary.opacity(show ? (dark ? 0.05 : 0.25):0).edgesIgnoringSafeArea(.all))
            }
        }.onAppear{
            if currentUser?.uid != nil {
                checkUser.checkUserInPlace()
            }
        }
    }
}


struct CustomerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerHomeView()
    }
}

struct CategoriesCell: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            Text("Kategoriler")
                .font(.largeTitle)
            ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing:10){
                    ForEach(categories,id:\.self) { i in
                        NavigationLink(destination: PlacesView(type:i))
                        {
                            VStack{
                                Image(i)
                                    .resizable()
                                    .frame(width:UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.15)
                                    .cornerRadius(20)
                                Text(i)
                                    .font(.title2)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
            }
        }
        //.padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        //.background(Color("back"))
        .cornerRadius(20)
        //.shadow(color: .purple, radius: 5)
    }
}

struct PlacesCell: View {
    
    //@StateObject private var businessArray=BusinessesViewModel()
    @StateObject private var businessPhotos=BusinessPhotoViewModel()
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            Text("Mekanlar")
                .font(.largeTitle)
            ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing:10){
                    ForEach(businessPhotos.placeModels) { i in
                        if Auth.auth().currentUser?.uid == nil {
                            NavigationLink(destination: Login_SignInView()) {
                                VStack{
                                    AnimatedImage(url: URL(string: i.imageUrl))
                                    //Image(i)
                                        .resizable()
                                        .frame(width:UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.225)
                                        .cornerRadius(20)
                                    Text(i.name)
                                        .font(.title)
                                        .foregroundColor(Color.black)
                                }
                            }
                        } else {
                            NavigationLink(destination: SelectedPlaceView(name: i.name)) {
                                VStack{
                                    AnimatedImage(url: URL(string: i.imageUrl))
                                    //Image(i)
                                        .resizable()
                                        .frame(width:UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.225)
                                        .cornerRadius(20)
                                    Text(i.name)
                                        .font(.title)
                                        .foregroundColor(Color.black)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            //businessArray.getAllBusinesses()
            businessPhotos.getProfilePhotoForUser(placeName: "")
        }
        //.padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        //.background(Color("back"))
        .cornerRadius(20)
        //.shadow(color: .purple, radius: 2)
        //.padding()
       
    }
}

struct CampaignCell: View {
    
    @State private var currentIndex : Int = 1
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    private var numberOfCampaign=3
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex){
                if Auth.auth().currentUser != nil {
                    ForEach(1..<numberOfCampaign+1,id:\.self) { i in
                        Image("pic\(i)")
                            .resizable()
                            .padding(.horizontal)
                    }
                } else {
                    ForEach(1..<numberOfCampaign+2,id:\.self) { i in
                        if i==1 {
                            VStack(spacing:10){
                                Text("Paysy'nin fırsatlarından ve kolaylıklarından yararlanmak için..").font(.body)
                                    .foregroundColor(Color.black).multilineTextAlignment(.center)
                                NavigationLink(destination: SignIn()) {
                                    Text("Üye Ol")
                                        .padding()
                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                        .background(Color.yellow)
                                        .foregroundColor(.white)
                                        .cornerRadius(20)
                                }
                                NavigationLink(destination: Login()) {
                                    Text("Giriş Yap")
                                        .padding()
                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                        .background(Color.yellow)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                }
                            }
                        } else {
                            Image("pic\(i-1)")
                                .resizable()
                                .padding(.horizontal)
                        }
                    }
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        
        .frame(width:UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.275)
        //.padding()
        //.background(Color("back"))
        .cornerRadius(20)
        //.shadow(color: .purple, radius: 2)
        .onReceive(timer, perform: { _ in
            withAnimation{
                if Auth.auth().currentUser != nil {
                    currentIndex = currentIndex < numberOfCampaign ? currentIndex + 1 : 1
                } else {
                    currentIndex = currentIndex < numberOfCampaign + 1 ? currentIndex + 1 : 1
                }
            }
        })
        CustomTabIndicator(count: (Auth.auth().currentUser != nil ) ? 3 : 4, current: $currentIndex)
    }
}

struct ProfileMenu : View {
    
    @Binding var dark : Bool
    @Binding var show : Bool
    @State private var showPersonalInfo = false
    @State private var showLoginInfo = false
    @State private var showAppInfo=false
    @State private var showInvite=false
    @State private var showHelp=false
    @State private var image:UIImage?
    @State private var showAddPhoto=false
    @State private var isShowPhotoLibrary=false
    @State private var isShowCamera=false
    
    @StateObject private var model=LoginAndSignInViewModel()
    @StateObject private var userInfo=UserInformationsViewModel()
    
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
            
            ZStack(alignment: .topTrailing ){
                if image != nil {
                    VStack{
                        HStack{
                            Button(action: {
                                image=nil
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            Button(action: {
                                userInfo.uploadProfilePhoto(selectPhoto: image!)
                            }) {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.blue)
                            }
                        }
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                } else if userInfo.profilePhoto != "" {
                    AnimatedImage(url: URL(string: userInfo.profilePhoto))
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    Button(action: {
                        userInfo.trashClicked()
                    }) {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                    }
                } else if userInfo.profilePhoto == "" {
                    VStack{
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        Button(action: {
                            showAddPhoto.toggle()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            VStack(spacing: 12){
                Text(userInfo.firstName)
                    .font(.caption)
            }
            .padding(.top,5)
            
            Group{
                Button(action: {
                    showPersonalInfo.toggle()
                }) {
                    HStack(spacing:22){
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Kişisel Bilgiler")
                            .fullScreenCover(isPresented: $showPersonalInfo) { () -> PersonalInformationView in
                                return PersonalInformationView(show: $showPersonalInfo)
                            }
                        Spacer()
                    }
                }
                .padding(.top,5)
                
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
                    showInvite.toggle()
                }) {
                    HStack(spacing:22){
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Davet Et").scaledToFill()
                            .fullScreenCover(isPresented: $showInvite) { () -> InviteSomeoneView in
                                return InviteSomeoneView(show: $showInvite)
                            }
                        Spacer()
                    }
                }
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
        .onAppear{
            userInfo.getProfilePhoto()
        }
        .alert(isPresented: $userInfo.showAlert, content: {
            Alert(title: Text(userInfo.alertTitle), message: Text(userInfo.alertMessage), dismissButton: .default(Text("Tamam")))
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
        .fullScreenCover(isPresented: $userInfo.showHome) { () -> CustomerHomeView in
            return CustomerHomeView()
        }
        .foregroundColor(.primary)
        .padding(.horizontal,20)
        .frame(width: UIScreen.main.bounds.width / 1.4,height: UIScreen.main.bounds.height * 1)
        .background((self.dark ? Color.black : Color.white))
        .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
        .onAppear{
            userInfo.getInfos()
        }
    }
}

struct ProfileMenuNotLogin : View {
    
    @Binding var dark : Bool
    @Binding var show : Bool
    @State private var showLogin=false
    @State private var showSignIn=false
    @State private var showAppInfo=false
    @State private var showInvite=false
    @State private var showHelp=false
    
    var body: some View {
        VStack(spacing:25){
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
            
            HStack{
                
                Button(action: {
                    showLogin.toggle()
                }) {
                    Text("Giriş Yap")
                        .foregroundColor(Color.yellow)
                        .frame(width: 100, height: 35)
                            .background(Color.black)
                            .clipShape(Capsule())
                }
                .fullScreenCover(isPresented: $showLogin) { () -> Login in
                    return Login(showDismissButton:"1")
                }
                Button(action: {
                    showSignIn.toggle()
                }) {
                    Text("Üye Ol")
                        .frame(width: 100, height: 35)
                        .foregroundColor(Color.yellow)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .fullScreenCover(isPresented: $showSignIn) { () -> SignIn in
                    return SignIn(showDismissButton: "1")
                }
            }
            Group{
                
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
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                        Text("Davet Et").scaledToFill()
                        Spacer()
                    }
                }
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
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
        .padding(.horizontal,20)
        .frame(width: UIScreen.main.bounds.width / 1.4,height: UIScreen.main.bounds.height * 1)
        .background((self.dark ? Color.black : Color.white))
        .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
    }
}
