//
//  MapView.swift
//  Paysy
//
//  Created by Anıl Demirci on 18.06.2022.
//

import SwiftUI
import MapKit
import Firebase

struct MapView: View {
    
    @StateObject private var mapViewModel=MapViewModel()
    
    @State private var mapRegion=MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.0330382, longitude: 28.4517462), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State private var locations = [Location]()
    
    @StateObject private var infomodel=BusinessInformationsViewModel()
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    @State var messageInput=""
    @State var titleInput=""
    @State var showingAlert=false
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapViewModel.region,showsUserLocation: true, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "mappin")
                            //.resizable()
                            .foregroundColor(.red)
                            //.frame(width: 32, height: 32)
                        Text(location.name)
                    }
                }
            }
            Circle()
                .fill(.blue).opacity(0.3).frame(width: 16, height: 16)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        //mapViewModel.getAddressFromLatLon(pdblLatitude: mapViewModel.region.center.latitude, withLongitude: mapViewModel.region.center.longitude)
                        
                        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                                           "Email":Auth.auth().currentUser!.email,
                                           "BusinessName":infomodel.placeName,
                                           "Town":mapViewModel.town,
                                           "City":infomodel.city,
                                           "Latitude":mapViewModel.region.center.latitude,
                                           "Longitude":mapViewModel.region.center.longitude,
                                           "AnnotationTitle":infomodel.placeName,
                                           "Date":FieldValue.serverTimestamp()] as [String:Any]
                        
                        firestoreDatabase.collection("Locations").document(currentUser!.uid).setData(firestoreUser) {
                                error in
                                if error != nil {
                                    titleInput="Hata"
                                    messageInput=error?.localizedDescription ?? "Sistem hatası tekrar deneyiniz."
                                    showingAlert.toggle()
                                } else {
                                    locations.removeAll(keepingCapacity: false)
                                    let newLocation=Location(id:UUID(),name: infomodel.placeName, latitude: mapViewModel.region.center.latitude,longitude: mapViewModel.region.center.longitude)
                                    locations.append(newLocation)
                
                                    titleInput="Başarılı"
                                    messageInput="Konumuz kaydedildi."
                                    showingAlert.toggle()
                                }
                            }
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding().background(Color.black.opacity(0.75)).foregroundColor(.white).font(.title).clipShape(Circle()).padding(.trailing)
                }
            }
        }.onAppear{
            infomodel.getInfos()
            mapViewModel.checkIfLocationServicesIsEnabled()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("OK!")))
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

