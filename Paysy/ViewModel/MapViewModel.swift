//
//  MapViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 18.06.2022.
//

import MapKit

enum MapDetails {
    
    static let startingLocation=CLLocationCoordinate2D(latitude: 41.0087247, longitude: 28.9790646)
    static let defaultSpan=MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
}

class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @Published var region=MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var town=""
    @Published var street=""
    @Published var village=""
    @Published var street2=""
    @Published var address=""
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager=CLLocationManager()
            locationManager!.delegate=self
        } else {
            //alert göster konuma izin vermesi gerektiğini
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Konumuz kısıtlanmıştır(ebeveyn denetimleri gibi)")
        case .denied:
            print("Konumuza izin verilmedi ayarlardan düzeltin.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
        @unknown default:
            break
        }
    }

    //adresi getiriyor edit infoda kullan
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = pdblLatitude
            center.longitude = pdblLongitude

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        self.town=pm.locality!
                        self.village=pm.subLocality!
                        self.street=pm.thoroughfare ?? ""
                        self.street2=pm.name!
                        
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        self.address=addressString
                        print(addressString)
                  }
            })

        }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}
