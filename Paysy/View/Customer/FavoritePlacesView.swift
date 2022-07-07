//
//  FavoritePlacesView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct FavoritePlacesView: View {
    @State var searchPlace=""
    @StateObject private var favPlace=UserInformationsViewModel()
    var body: some View {
        
        //eğer giriş yapılmadan basılırsa çöküyor uygulama. fav mekan yoksa yazı göster.
        
        NavigationView {
            VStack{
                HStack(){
                    Image(systemName: "magnifyingglass")//.font(.system(size: 23,weight: .bold))
                        .foregroundColor(.gray)
                    TextField("Mekan ara",text: $searchPlace)
                }.padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                List{
                    ForEach(searchPlace == "" ? favPlace.userFavPlaces : favPlace.userFavPlaces.filter{$0.contains(searchPlace)},id:\.self) { i in
                        NavigationLink(destination: SelectedPlaceView(name: i)) {
                            VStack{
                                    HStack{
                                        Text(i)
                                            .font(.title)
                                        Spacer()
                                        //Text("Puan: \(i.point,specifier: "%.2f")")
                                    }
                                Image(i)
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
