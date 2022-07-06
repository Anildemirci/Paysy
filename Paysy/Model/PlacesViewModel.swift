//
//  PlacesViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 26.04.2022.
//

import Foundation

//databaseden verileri buna göre çek 
struct placesInfo: Identifiable,Decodable,Hashable {
    var id: Int
    var name : String
    var location : String
    var point : Double
    var type : String
}

var placesArray=[
    placesInfo(id: 0, name: "Fil", location: "Moda,Kadıköy", point: 4.0, type: "Bar"),
    placesInfo(id: 1, name: "Bausta", location: "Suadiye", point: 4.5, type: "Bar"),
    placesInfo(id: 2, name: "DorockXL", location: "Caferağa,Kadıköy", point: 4.0, type: "Eğlence"),
    placesInfo(id: 3, name: "RoseMary", location: "Kayışdağı,Ataşehir", point: 2.5, type: "Kahve"),
    placesInfo(id: 4, name: "Ayı", location: "Caferağa,Kadıköy", point: 3.5, type: "Eğlence"),
    placesInfo(id: 5, name: "Viktor Levi", location: "Caferağa,Kadıköy", point: 4.0, type: "Bar")
]
