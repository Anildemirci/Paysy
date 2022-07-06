//
//  BusinessPhotosView.swift
//  Paysy
//
//  Created by Anıl Demirci on 21.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BusinessPhotosView: View {
    
    @State private var showEdit=false
    @State private var show=false
    @State private var url=""
    @StateObject var photosInfo=BusinessPhotoViewModel()
    var placeName=""
    
    var body: some View {
        VStack(alignment: .center){
            if photosInfo.posts.isEmpty {
                Text("Saha tarafından henüz fotoğraf yüklenmedi.").fontWeight(.heavy)
            } else {
                List {
                    ForEach(photosInfo.posts){ i in
                        PhotosStructView(statement: i.statement, image: i.image, id: i.id, show: $show, url: $url)
                    }.onDelete(perform: photosInfo.deletePhoto)
                }.listStyle(.plain)
            }
    }.padding()
        .navigationBarItems(trailing:
                                Button(action: {
            showEdit.toggle()
        }){
            Text("Fotoğraf Yükle")
            //Image(systemName: "plus").resizable().frame(width: 25, height: 25).foregroundColor(Color.blue)
        })
        .fullScreenCover(isPresented: $showEdit) { () -> PhotoUploadView in
            PhotoUploadView()
        }
        .onAppear{
            photosInfo.placeName=placeName
            photosInfo.getDataForStadium()
        }
}

struct BusinessPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessPhotosView()
    }
}

struct PhotosStructView : View {
    
    var statement=""
    var image=""
    var id=""
    @Binding var show : Bool
    @Binding var url : String
    
    var body: some View {
        VStack{
            AnimatedImage(url: URL(string: image))
                .resizable()
                .frame(height:UIScreen.main.bounds.height * 0.35)
                .onTapGesture {
                    url=image
                    show.toggle()
                }
            HStack{
                Text(statement)
            }
        }
        .sheet(isPresented: $show){
            statusView(url: url)
        }
    }
}

struct PhotoUploadView : View {
    
    @State var image:UIImage?
    @State var isShowCamera=false
    @State var isShowPhotoLibrary=false
    @State var statement=""
    @State var show=false
    @StateObject var businessPhoto=BusinessPhotoViewModel()
    @StateObject var businessInfo=BusinessInformationsViewModel()
    
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
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color.black)
            Spacer()
            if image != nil{
                Button(action: {
                    businessPhoto.placeName=businessInfo.placeName
                    businessPhoto.uploadPhoto(selectPhoto: image!)
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
}

//ilk tıklamada fotoğraf gelmiyor düzelt
struct statusView:View{
    @State var url=""
    var body: some View{
        ZStack{
            AnimatedImage(url: URL(string: url))
                .resizable()
                //.scaledToFit()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

//düzelt
struct ThePhotoView : View {
    
    @State var url=""
    @StateObject var photoInfo=BusinessPhotoViewModel()

    var body: some View {
        GeometryReader { proxy in
            TabView{
                ForEach(0..<5){ num in
                    AnimatedImage(url: URL(string: url))
                        .resizable()
                        .scaledToFill()
                        .tag(num)
                }
            }.tabViewStyle(PageTabViewStyle())
                .frame(width: proxy.size.width, height: proxy.size.height )
        }.onAppear{
            photoInfo.getDataForStadium()
        }
    }
}
