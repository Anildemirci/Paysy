//
//  PlacePhotosView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlacePhotosView: View {
    
    @StateObject private var photoInfo=BusinessPhotoViewModel()
    @State private var show=false
    @State private var url=""
    
    var body: some View {
        VStack(alignment: .center){
            if photoInfo.posts.isEmpty==true {
                Text("Saha tarafından henüz fotoğraf yüklenmedi.").fontWeight(.heavy)
            } else {
                List {
                    ForEach(photoInfo.posts){ i in
                        PhotosStructView(statement: i.statement, image: i.image, id: i.id, show: $show, url: $url)
                    }
                }.listStyle(.plain)
            }
    }.padding()
            .onAppear{
                photoInfo.getBusinessPhotoForUser()
            }
    }
}

struct PlacePhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PlacePhotosView()
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
