//
//  CommentViewModel.swift
//  Paysy
//
//  Created by Anıl Demirci on 7.07.2022.
//

import Foundation
import Firebase
import SwiftUI
import Combine

class CommentViewModel : ObservableObject {
    
    @Published var titleInput=""
    @Published var messageInput=""
    @Published var alertType=""
    @Published var showAlert=false
    @Published var score=[String]()
    @Published var comment=[String]()
    @Published var date=[String]()
    @Published var commentArray=[String]()
    @Published var documentID=""
    @Published var userName=[String]()
    @Published var totalScore=Double()
    @Published var commentsArrayStruct = [commentInfoModel]()
    
    private var currentTime=""
    private let currentUser=Auth.auth().currentUser
    private let firestoreDatabase=Firestore.firestore()
    var didChange=PassthroughSubject<Array<Any>,Never>()
    
    func getCurrentTime(){
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        formatter.timeZone=TimeZone(abbreviation: "UTC+3")
        currentTime=formatter.string(from: date)
    }
    
    func sendComment(placeName: String, comment: String, score: String,fullName:String){
        getCurrentTime()
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser!.email!,
                           "Place Name":placeName,
                           "Comment":comment,
                           "Score":score,
                           "FullName":fullName,
                           "CommentDate":currentTime] as [String:Any]
        
        if score != "Lütfen puan seçiniz" && comment != "" {
            firestoreDatabase.collection("Evaluation").document(placeName).collection(placeName).document(currentTime).setData(firestoreUser) { error in
                if error != nil {
                    self.alertType="success"
                    self.titleInput="Hata"
                    self.messageInput=error?.localizedDescription ?? "Sistem hatası lütfen tekrar deneyiniz."
                    
                } else {
                    self.alertType="success"
                    self.titleInput="Başarılı"
                    self.messageInput="Yorum ve puanlamanız için teşekkür ederiz."
                    
                }
            }
        } else {
            self.titleInput="Hata"
            self.messageInput="Lütfen yorum/puan kısmını boş bırakmayınız."
        }
    }
    
    func getComment(placeName: String){
        var i=0
        
        firestoreDatabase.collection("Evaluation").document(placeName).collection(placeName).order(by: "CommentDate",descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.titleInput="Hata"
                self.messageInput=error?.localizedDescription ?? "Sistem hatası lütfen tekrar deneyiniz."
                self.showAlert.toggle()
            } else {
                
                self.commentsArrayStruct.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents {
                    let comments = document.get("Comment") as! String
                    let username = document.get("FullName") as! String
                    let commentDate = document.get("CommentDate") as! String
                    let scorePoint = document.get("Score") as! String
                    i=i+1
                        if scorePoint.contains("5-Çok iyi") {
                            self.totalScore=(self.totalScore+5.00)
                        } else if scorePoint.contains("4-İyi") {
                            self.totalScore=(self.totalScore+4.00)
                        } else if scorePoint.contains("3-Orta") {
                            self.totalScore=(self.totalScore+3.00)
                        } else if scorePoint.contains("2-Kötü") {
                            self.totalScore=(self.totalScore+2.00)
                        } else if scorePoint.contains("1-Çok kötü") {
                            self.totalScore=(self.totalScore+1.00)
                        }
                    self.commentsArrayStruct.append((commentInfoModel(id: document.documentID, comment: comments, fullname: username, date: commentDate, score: scorePoint)))
                }
                if i != 0 {
                    self.totalScore=self.totalScore/Double(i)
                } else {
                    self.totalScore=0.00
                }
                self.didChange.send(self.commentsArrayStruct)
            }
        }
    }
}
