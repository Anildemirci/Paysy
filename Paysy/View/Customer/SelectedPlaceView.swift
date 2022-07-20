//
//  SelectedPlaceView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct SelectedPlaceView: View {
    var name=""
    @State private var selected=1
    @StateObject private var favPlace=UserInformationsViewModel()
    @StateObject private var businessPhotos=BusinessPhotoViewModel()
    
    var body: some View {
        VStack{
            AnimatedImage(url: URL(string: businessPhotos.placeProilPhoto))
            //Image(name)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.3)
            HStack{
                Button(action: {
                    placeNameFromUser=name
                    selected=0
                }) {
                    Text("Fotoğraflar")
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
                if selected == 0 {
                    PlacePhotosView()
                } else if selected == 1 {
                    PlaceInformationsView(placeName: name)
                } else {
                    PlaceCommentsView(placeName: name)
                }
            }
            Spacer()
                .navigationTitle(name).navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button(action: {
                        if favPlace.userFavPlaces.contains(name) {
                            favPlace.delFavorite(placeName: name)
                        } else {
                            favPlace.addFavorite(placeName: name)
                        }
                    }) {
                        if favPlace.userFavPlaces.contains(name) {
                            Image(systemName: "star.fill").resizable().frame(width: 30, height: 30)
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star").resizable().frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                })
                    .alert(isPresented: $favPlace.showAlert){
                        Alert(title: Text(favPlace.alertTitle), message: Text(favPlace.alertMessage), dismissButton: .default(Text("Tamam")))
                    }
        }.onAppear{
            favPlace.getInfos()
            businessPhotos.getProfilePhotoForUser(placeName: name)
        }
    }
}

struct SelectedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPlaceView()
    }
}
