//
//  PlaceCommentModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 26.04.2022.
//

import Foundation

struct placesCommentInfo: Identifiable,Decodable,Hashable {
    var id=UUID()
    var name : String
    var date : String
    var point : Int
    var comment : String
}

var comments=[
    placesCommentInfo(name: "Anıl Demirci", date: "17.05.2021", point: 4, comment: "Mekanı çok beğendim, çalışanlar güler yüzlü ve hızlılar."),
    placesCommentInfo(name: "Anıl Demirci", date: "07.02.2021", point: 3, comment: "Mekandan çok beklentim yoktu, ortalama bir puana sahipler."),
    placesCommentInfo(name: "Anıl Demirci", date: "12.01.2028", point: 4, comment: "Mekanın manzarasını çok beğendim, kokteyller de bir o kadar güzeldi."),
    placesCommentInfo(name: "Anıl Demirci", date: "05.03.2021", point: 2, comment: "Mekanı çok beğendiğimi söyleyemeyeceğim."),
    placesCommentInfo(name: "Anıl Demirci", date: "08.02.2022", point: 3, comment: "Bu fiyatlara göre beklenen kalite ve hizmet."),
    placesCommentInfo(name: "Anıl Demirci", date: "28.01.2021", point: 1, comment: "Yemekler soğuk geldi, servis genel olarak çok yavaştı ve lezzetli değildi."),
    placesCommentInfo(name: "Anıl Demirci", date: "23.04.2019", point: 5, comment: "Mekanı çok beğendim, her şey çok iyiydi herkese tavsiye ediyorum.")
]
