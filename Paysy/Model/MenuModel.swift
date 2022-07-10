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
