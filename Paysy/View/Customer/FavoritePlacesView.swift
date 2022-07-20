//
//  FavoritePlacesView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritePlacesView: View {
    @State private var searchPlace=""
    @StateObject private var favPlace=UserInformationsViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack{
                HStack(){
                    Image(systemName: "magnifyingglass")//.font(.system(size: 23,weight: .bold))
                        .foregroundColor(.gray)
                    TextField("Mekan ara",text: $searchPlace)
                        .autocapitalization(.words)
                }.padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                List{
                    ForEach(searchPlace == "" ? favPlace.placeModels : favPlace.placeModels.filter{$0.name.localizedCaseInsensitiveContains(searchPlace)}) { i in
                        NavigationLink(destination: SelectedPlaceView(name: i.name)) {
                            VStack{
                                    HStack{
                                        Text(i.name)
                                            .font(.title)
                                        Spacer()
                                        //Text("Puan: \(i.point,specifier: "%.2f")")
                                    }
                                AnimatedImage(url: URL(string: i.imageUrl))
                                //Image(i.imageUrl)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
                                        .cornerRadius(20)
                                //Text(i.location)
                            }
                        }
                    }
                }.listStyle(.plain)
                    .navigationTitle("Favoriler").navigationBarTitleDisplayMode(.inline)
            }
            .onAppear{
                favPlace.getInfos()
            }
        }
    }
}

struct FavoritePlacesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePlacesView()
    }
}
