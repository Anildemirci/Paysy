//
//  PinView.swift
//  Paysy
//
//  Created by Anıl Demirci on 18.06.2022.
//

import SwiftUI
import MapKit
import Firebase

//pini işaretlediğin yerin koordinatları, posta kodu, bölge adı gibi bilgilerini veriyor.
//henüz bir yerde kullanılmıyor.

struct PinView: View {
    @StateObject private var mapViewModel=MapViewModel()
    
    var body: some View {
        VStack {
            DraggableMapView(latitude: mapViewModel.region.center.latitude, longitude: mapViewModel.region.center.longitude)
        }.onAppear{
            mapViewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView()
    }
}

struct DraggableMapView : UIViewRepresentable {
    
    @State var latitude = Double()
    @State var longitude = Double()
    
    func makeCoordinator() -> Coordinator {
        return DraggableMapView.Coordinator(parent1: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        
        let coordinate=CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        map.region=MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        let annotation=MKPointAnnotation()
        annotation.coordinate=coordinate
        
        map.delegate=context.coordinator
        map.addAnnotation(annotation)
        
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator : NSObject,MKMapViewDelegate {
        var parent:DraggableMapView
        
        init(parent1:DraggableMapView) {
            parent=parent1
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin=MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable=true
            pin.pinTintColor = .red
            pin.animatesDrop = true
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)) { (places, error)  in
                
                print((places?.first?.name)!) //cadde sokak adres
                print((places?.first?.locality)!) // ilçe
                print((places?.first?.subLocality)) //mahalle
            }
        }
        
    }
}

