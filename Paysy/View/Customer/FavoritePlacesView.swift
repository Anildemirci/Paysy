//
//  FavoritePlacesView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct FavoritePlacesView: View {
    @State var searchPlace=""
    
    var body: some View {
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
                    ForEach(searchPlace == "" ? placesArray : placesArray.filter{$0.name.contains(searchPlace)},id:\.self) { i in
                        NavigationLink(destination: SelectedPlaceView(name: i.name)) {
                            VStack{
                                    HStack{
                                        Text(i.name)
                                            .font(.title)
                                        Spacer()
                                        Text("Puan: \(i.point,specifier: "%.2f")")
                                    }
                                Image(i.name)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
                                        .cornerRadius(20)
                                Text(i.location)
                            }
                        }
                    }
                }.listStyle(.plain)
                    .navigationTitle("Favoriler").navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct FavoritePlacesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePlacesView()
    }
}
