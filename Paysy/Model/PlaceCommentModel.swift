//
//  PlaceCommentModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 26.04.2022.
//

import Foundation

struct commentInfoModel : Identifiable,Codable {
    var id : String
    var comment : String
    var fullname : String
    var date : String
    var score : String
}

