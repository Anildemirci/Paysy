//
//  BusinessInformationsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 21.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BusinessInformationsView: View {
    
    @State private var showEdit=false
    @StateObject private var businessInfo=BusinessInformationsViewModel()
    @StateObject private var businessPhoto=BusinessPhotoViewModel()
    @State var placeName=""
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                HStack{
                     Spacer()
                     Button(action: {
                         print(businessInfo.placeName)
                         showEdit.toggle()
                     }) {
                         Text("Düzenle")
                     }
                 }
                Text("İletişim Bilgileri")
                    .font(.title2)
                    .fontWeight(.medium)
                    VStack{
                        HStack{
                            Image(systemName: "map.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(businessInfo.address)
                        }
                        Button(action: {
                            
                        }) {
                            HStack(){
                                Spacer()
                                Image(systemName: "location")
                                    .frame(width: 25, height: 25)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                Text("Yol tarifi al")
                                    .foregroundColor(.white)
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.075)
                        }
                        .background(Color.blue)
                        
                        Button(action: {
                            
                        }) {
                            HStack(){
                                Spacer()
                                Image(systemName: "phone")
                                    .frame(width: 25, height: 25)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                Text(businessInfo.phoneNumber)
                                    .foregroundColor(.white)
                                Spacer()
                            }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.075)
                        }
                        .background(Color.green)
                    }
                Text("Çalışma Saatleri")
                    .font(.title2)
                    .fontWeight(.medium)
                VStack{
                    Text("Açılış Saati: \(businessInfo.openingTime)")
                    Text("Kapanış Saati: \(businessInfo.closingTime)")
                }
                Text("Menü")
                    .font(.title2)
                    .fontWeight(.medium)
                VStack{
                    if businessPhoto.posts.isEmpty {
                        Text("Henüz fotoğraf yüklemediniz")
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(businessPhoto.imageUrl,id:\.self) { i in
                                    AnimatedImage(url: URL(string: i))
                                        .resizable()
                                        .frame(width:UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.225)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            businessInfo.getInfos()
            businessPhoto.getBusinessMenuPhotoForUser(placeName: placeName)
        }
        .fullScreenCover(isPresented: $showEdit) { () -> EditBusinessInformations in
            return EditBusinessInformations()
        }
    }
}

struct BusinessInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessInformationsView()
    }
}


//edit view

struct EditBusinessInformations: View {
    @State private var show=false
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                CustomDismissButton(show: $show)
                EditLocation()
                EditAddressInformations()
                EditWorkingHour()
                AddMenuPhotosView()
            }
        }.fullScreenCover(isPresented: $show) { () -> BusinessAccountView in
            return BusinessAccountView()
        }
    }
}

struct EditAddressInformations: View {
    
    @StateObject var businessInfo=BusinessInformationsViewModel()
    //@StateObject var addressInfo=MapViewModel()
    
    var body: some View {
        VStack{
            Spacer()
            Text("İletişim Bilgileri")
                .font(.title)
                .fontWeight(.medium)
            Group {
                TextField("telefon", text: $businessInfo.phoneNumber)
                    .keyboardType(.numberPad)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                TextField("mahalle", text: $businessInfo.village)
                    .autocapitalization(.words)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                TextField("cadde,sokak,no", text: $businessInfo.street)
                    .frame(height: UIScreen.main.bounds.height * 0.020)
                    .autocapitalization(.words)
                    .padding()
                    .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                HStack{
                    TextField("ilçe", text: $businessInfo.town)
                        .autocapitalization(.words)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                    TextField("İl", text: $businessInfo.city)
                        .autocapitalization(.words)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                }
            }
            .background(Color.white)
            Button(action: {
                businessInfo.updateInfo()
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
        .alert(isPresented: $businessInfo.showAlert, content: {
            Alert(title: Text(businessInfo.alertTitle), message: Text(businessInfo.alertMessage), dismissButton: .default(Text("Tamam")))
    })
        .onAppear{
            businessInfo.getInfos()
        }
    }
}

struct EditLocation: View {
    
    var body: some View {
        VStack{
            Text("Navigasyon için iş yerinizin konumunu ekleyin.")
                .font(.headline)
                .foregroundColor(Color.white)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            MapView()
            .frame(height:UIScreen.main.bounds.height * 0.35)
        }
    }
}


struct EditWorkingHour: View {
    
    @StateObject private var businessInfo=BusinessInformationsViewModel()
    
    var body: some View {
        VStack {
            Text("Çalışma Saatleri")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color.black)
            HStack{
                TextField("Açılış saati (12:00)", text: $businessInfo.openingTime)
                    .keyboardType(.numbersAndPunctuation)
                    .padding()
                    .border(Color.black, width: 1)
                TextField("Kapanış saati (02:00)", text: $businessInfo.closingTime)
                    .keyboardType(.numbersAndPunctuation)
                    .padding()
                    .border(Color.black, width: 1)
            }
            Button(action: {
                businessInfo.businessWorkingHour()
            })
            {
                Text("Onayla")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .alert(isPresented: $businessInfo.showAlert, content: {
            Alert(title: Text(businessInfo.alertTitle), message: Text(businessInfo.alertMessage), dismissButton: .default(Text("Tamam")))
    })
    }
}

struct AddMenuPhotosView: View {
    
    @State private var show=false
    
    var body: some View {
        VStack{
            Text("Menü Fotoğrafları")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color.black)
            Button(action: {
                show.toggle()
            }) {
                Text("Fotoğraf Yükle")
                    //.font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }.sheet(isPresented: $show) {
            MenuPhotoUploadView()
        }
    }
}

struct MenuPhotoUploadView : View {
    
    @State private var image:UIImage?
    @State private var isShowCamera=false
    @State private var isShowPhotoLibrary=false
    @State private var show=false
    @StateObject private var businessPhoto=BusinessPhotoViewModel()
    @StateObject private var businessInfo=BusinessInformationsViewModel()
    
    var body: some View {
        VStack{
            CustomDismissButton(show: $show)
            Spacer()
            if image != nil {
                Image(uiImage: image!)
                                .resizable()
                                .scaledToFit()
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                                .frame(minWidth: 0, maxWidth: .infinity,maxHeight: UIScreen.main.bounds.width * 1)
                                .padding(.horizontal)
                                
            } else {
                Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.6)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(.horizontal)
            }
                        Button(action: {
                            self.isShowPhotoLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 20))
                                Text("Fotoğraflar")
                                    .font(.headline)
                            }
                            //.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                            .frame(width: 300, height: 60 )
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.horizontal)
                        }
            Button(action: {
                self.isShowCamera = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                    Text("Kamera")
                        .font(.headline)
                }
                //.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .frame(width: 300, height: 60 )
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.horizontal)
            }
            Spacer()
            TextField("Açıklama", text: $businessPhoto.statement)
                .font(.title3)
                .autocapitalization(.sentences)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                .padding()
                .overlay(Rectangle().stroke(Color.black,lineWidth:1))
            Spacer()
            if image != nil{
                Button(action: {
                    businessPhoto.placeName=businessInfo.placeName
                    businessPhoto.addMenuPhotos(selectPhoto: image!)
                    image=nil
                    
                }) {
                    Text("Yükle")
                        //.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                        .frame(width: 300, height: 60 )
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                }
            }
            Spacer()
        }
        .onAppear{
            businessInfo.getInfos()
        }
        .fullScreenCover(isPresented: $show) { () -> BusinessAccountView in
            BusinessAccountView()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
        .sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $image)
        }
        .alert(isPresented: $businessPhoto.showingAlert, content: {
            Alert(title: Text(businessPhoto.titleInput), message: Text(businessPhoto.messageInput), dismissButton: .default(Text("Tamam")))
        })
    }
}
