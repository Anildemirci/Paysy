//
//  PlacesView.swift
//  Paysy
//
//  Created by Anıl Demirci on 14.04.2022.
//

import SwiftUI

struct PlacesView: View {
    
    @State private var searchPlace=""
    //@State private var show=false
    @StateObject private var businessInfo=BusinessesViewModel()
    var type=""
    var town=""
    
    var body: some View {
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
            List(searchPlace == "" ? businessInfo.businessArray : businessInfo.businessArray.filter{$0.localizedCaseInsensitiveContains(searchPlace)},id: \.self){ i in
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
                
            }.listStyle(.plain)
                .navigationBarTitle(town,displayMode: .inline)
        }
        .onAppear{
            businessInfo.getBusinesses(town: town)
        }
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView()
    }
}


