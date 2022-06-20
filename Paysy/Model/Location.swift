//
//  Location.swift
//  Paysy
//
//  Created by Anıl Demirci on 18.06.2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable,Codable,Equatable {
    var id: UUID
    var name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


