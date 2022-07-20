//
//  PlaceInformationsModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 26.04.2022.
//

import Foundation

struct placesInformations: Identifiable,Decodable,Hashable {
    var id=UUID()
    var name : String
    var address : String
    var city : String
    var town : String
    var openingTime : String
    var closingTime : String
}

struct townNameModel: Identifiable,Codable {
    var id=UUID()
    var town:String
}
