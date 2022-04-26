//
//  CreditCardModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 26.04.2022.
//

import Foundation

struct Card: Identifiable {
    var id=UUID().uuidString
    var cardName : String
    var cardHolder : String
    var cardNumber : String
    var cardValidity : String
    var cardImage : String
}

var cards=[
    Card(cardName: "Finansbak",cardHolder: "Anıl Demirci", cardNumber: "1234 4322 4324 5439", cardValidity: "21-01-2025", cardImage: "card1"),
    Card(cardName: "Garanti",cardHolder: "Anıl Demirci", cardNumber: "0254 4292 3324 1479", cardValidity: "15-04-2023", cardImage: "card2"),
    Card(cardName: "Akbank",cardHolder: "Anıl Demirci", cardNumber: "0435 6322 4053 5037", cardValidity: "11-11-2024", cardImage: "card1"),
    Card(cardName: "Ziraat",cardHolder: "Anıl Demirci", cardNumber: "3415 3362 4351 5597", cardValidity: "11-01-2026", cardImage: "card2")
]

