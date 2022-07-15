//
//  MenuModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 10.07.2022.
//

import Foundation

struct menuModel : Identifiable,Hashable {
    var id : String
    var statement : String
    var price : String
    var itemName : String
    var MenuType : String
    var SubMenuType : String
}

struct orderModel: Identifiable, Hashable, Codable {
    
    public var id=UUID().uuidString
    var statement : String
    var price : String
    var itemName : String
    var status : String
    var amount : Int
    
    var dictionary: [String:Any] {
        return [
            "statement":statement,
            "price:":price,
            "itemName":itemName,
            "status":status,
            "amount":amount,
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case statement
        case price
        case itemName
        case status
        case amount
    }
    
}


