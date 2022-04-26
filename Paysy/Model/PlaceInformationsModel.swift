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

var placeInfos=[
    placesInformations(name: "DorockXL", address: "Caferağa, Namlı Market Yanı, Neşet Ömer Sk. 3C, 34710 Kadıköy/İstanbul", city: "İstanbul", town: "Kadıköy", openingTime: "12:00", closingTime: "04:00"),
    placesInformations(name: "Viktor Levi", address: "Caferağa Mh Moda Cd. &, Damacı Sk. No:4, 34710 Kadıköy", city: "İstanbul", town: "Kadıköy", openingTime: "11:00", closingTime: "02:00"),
    placesInformations(name: "Fil", address: "Caferağa Mah., Moda Cad. 66/A, 34710 Kadıköy/İstanbul", city: "İstanbul", town: "Kadıköy", openingTime: "12:00", closingTime: "04:00"),
    placesInformations(name: "RoseMary", address: "Kayışdağı, Baykal Sk. 9 A, 34755 Dudullu Osb/Ataşehir/İstanbul", city: "İstanbul", town: "Ataşehir", openingTime: "12:00", closingTime: "03:00"),
    placesInformations(name: "Bausta", address: "Suadiye, Ayşeçavuş Cd no:9, 34740 Kadıköy/İstanbul", city: "İstanbul", town: "Suadiye", openingTime: "12:00", closingTime: "03:00")
]
