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
    
    var id=UUID().uuidString
    var statement : String
    var price : String
    var itemName : String
    var status : String
    var amount : Int
    
}

struct getOrderModelForCustomer: Identifiable,Codable{
    var id=UUID().uuidString
    var statement : String
    var price : String
    var itemName : String
    var status : String
    var amount : Int
    var note : String
    var tableNum : String
    var userFullName : String
}

struct orderModelForBusiness: Identifiable,Hashable,Codable {
    var id=UUID().uuidString
    var statement : String
    var price : String
    var itemName : String
    var status : String
    var amount : Int
    var note : String
    var tableNum : String
}


