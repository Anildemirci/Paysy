//
//  TownsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 14.04.2022.
//

import SwiftUI

struct TownsView: View {
    
    @State private var searchText=""
    @StateObject private var businessViewModel=BusinessesViewModel()
    
    var body: some View {
            NavigationView{
                VStack{
                    HStack(){
                        Image(systemName: "magnifyingglass")//.font(.system(size: 23,weight: .bold))
                            .foregroundColor(.gray)
                        TextField("İlçe ara",text: $searchText)
                            .autocapitalization(.words)
                    }.padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(8)
                    List(searchText == "" ? businessViewModel.townArray : businessViewModel.townArray.filter{$0.localizedCaseInsensitiveContains(searchText.lowercased())}, id: \.self){ towns in
                        NavigationLink(destination: PlacesView(town: towns)) {
                            Text(towns)
                        }
                    }.listStyle(.plain)
                }
                .navigationBarTitle("İstanbul",displayMode: .inline)
                .onAppear{
                    businessViewModel.getTowns()
                }
            }
    }
}

struct TownsView_Previews: PreviewProvider {
    static var previews: some View {
        TownsView()
    }
}


/*
 var town=["Adalar", "Arnavutköy", "Ataşehir", "Avcılar", "Bağcılar", "Bahçelievler", "Bakırköy", "Başakşehir", "Bayrampaşa", "Beşiktaş", "Beykoz", "Beylikdüzü", "Beyoğlu", "Büyükçekmece", "Çatalca", "Çekmeköy", "Esenler", "Esenyurt", "Eyüpsultan", "Fatih", "Gaziosmanpaşa", "Güngören", "Kadıköy", "Kağıthane", "Kartal", "Küçükçekmece", "Maltepe", "Pendik", "Sancaktepe", "Sarıyer", "Silivri", "Sultanbeyli", "Sultangazi", "Şile", "Şişli", "Tuzla","Ümraniye","Üsküdar","Zeytinburnu"]
 */

