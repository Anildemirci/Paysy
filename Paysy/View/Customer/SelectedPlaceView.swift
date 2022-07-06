//
//  SelectedPlaceView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct SelectedPlaceView: View {
    var name=""
    @State private var selected=1
    
    var body: some View {
        VStack{
            Image(name)
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
                    PlaceInformationsView()
                } else {
                    PlaceCommentsView()
                }
            }
            Spacer()
                .navigationTitle(name).navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button(action: {
                        
                    }) {
                        Image(systemName: "star")
                            .foregroundColor(.white)
                })
        }
    }
}

struct SelectedPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPlaceView()
    }
}
