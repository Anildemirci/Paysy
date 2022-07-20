//
//  PlaceModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 20.07.2022.
//

import Foundation

struct placeModel: Identifiable,Hashable {
    
    var id = UUID().uuidString
    var name : String
    var imageUrl : String
}
