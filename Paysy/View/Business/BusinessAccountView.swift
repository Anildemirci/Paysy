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
    
    @StateObject var businessInfo=BusinessInformationsViewModel()
    @StateObject var businessPhoto=BusinessPhotoViewModel()
    
    var body: some View {
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
                            BusinessCommentsView()
                        }
                    }
                    Spacer()
                    
                        .navigationTitle(businessInfo.placeName).navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(leading:
                                                Button(action: {
                            if image != nil {
                                image=nil
                            }
                            }){
                                if image != nil {
                                    Image(systemName: "xmark").resizable().frame(width: 25, height: 25)
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
                                Image(systemName: "checkmark").resizable().frame(width: 25, height: 25).foregroundColor(Color.blue)
                            } else if businessPhoto.profilPhoto == "" && image == nil {
                                Image(systemName: "plus").resizable().frame(width: 25, height: 25).foregroundColor(Color.blue)
                            } else if businessPhoto.profilPhoto != "" {
                                Image(systemName: "trash").resizable().frame(width: 25, height: 25).foregroundColor(Color.blue)
                            }
                        })
                }
            }
            .onAppear{
                businessInfo.getInfos()
                businessPhoto.getProfilePhoto()
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
}
    
}

struct BusinessAccountView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessAccountView()
    }
}
