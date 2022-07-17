//
//  PlaceCommentsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct PlaceCommentsView: View {
    
    @State var placeName=""
    @StateObject private var placeCommentViewModel=CommentViewModel()
    
    var body: some View {
        VStack{
            if placeCommentViewModel.commentsArrayStruct.count == 0 {
                Text("Henüz yorum yapılmadı.")
            } else {
                let roundedValue=NSString(format: "%.2f",placeCommentViewModel.totalScore)
                Text("\(placeCommentViewModel.commentsArrayStruct.count) müşteri oyu ile \(roundedValue) puan.").padding()
                    .border(Color.black, width: 1)
                List(placeCommentViewModel.commentsArrayStruct){ i in
                    VStack(alignment: .leading,spacing: 10){
                        HStack{
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            Text(i.fullname)
                                .font(.subheadline)
                            Spacer()
                            if i.score == "5-Çok iyi"{
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "4-İyi" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "3-Orta" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "2-Kötü" {
                                Group {
                                    Image(systemName: "star.fill")
                                    Image(systemName: "star.fill")
                                }.foregroundColor(Color.yellow)
                            } else if i.score == "1-Çok kötü" {
                                Image(systemName: "star.fill").foregroundColor(Color.yellow)
                            }
                        }
                        Text(i.date)
                            .font(.footnote)
                        Text(i.comment)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                }.listStyle(.plain)
            }
            NavigationLink("Yorum Yap") {
                AddComment(placeName:placeName)
            }
        }
        .onAppear{
            placeCommentViewModel.getComment(placeName: placeName)
        }
    }
}

struct PlaceCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCommentsView()
    }
}

struct AddComment: View {
    
    @State var placeName=""
    @State private var comment=""
    @State private var points=["Lütfen puan seçiniz","1-Çok kötü","2-Kötü","3-Orta","4-İyi","5-Çok iyi"]
    @State private var selectedPoint="Lütfen puan seçiniz"
    @State private var alertType:AlertType?
    @State private var messageInput=""
    @State private var titleInput=""
    @State private var button=""
    @State private var button1=""
    @State private var button2=""
    @State private var show=false
    
    @StateObject var commentViewModel=CommentViewModel()
    @StateObject private var userInfo=UserInformationsViewModel()
    
    enum AlertType: Identifiable{
        case confirmAlert,showAlert
        
        var id: Int{
            hashValue
        }
    }
    
    var body: some View {
        VStack{
            Spacer()
            TextEditor(text: $comment)
                .navigationTitle("Yorum Yap")
                .frame(height: UIScreen.main.bounds.height * 0.20)
                .overlay(Rectangle().stroke(Color.black,lineWidth:1))
                .padding()
            HStack {
                Text("Puan: ")
                    .foregroundColor(Color.black)
                Spacer()
                Picker("Lütfen puan seçiniz", selection: $selectedPoint) {
                    ForEach(points,id:\.self) { score in
                        Text(score)
                            .foregroundColor(Color.black)
                    }
                }
                .accentColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
            }
                .padding()
                .background(Color.white)
                .border(Color.black, width: 1)
            .frame(width: UIScreen.main.bounds.width * 0.8)
            Button(action: {
                
                if comment != "" && selectedPoint != "Lütfen puan seçiniz" {
                    button="send"
                    titleInput="Onaylıyor musunuz?"
                    messageInput="Tekrar yorum yapamazsınız."
                    button1="Evet"
                    button2="Hayır"
                    alertType = .confirmAlert
                } else {
                    titleInput="Hata"
                    messageInput="Lütfen yorum/puan kısmını doldurunuz."
                    alertType = .showAlert
                }
                
            }) {
                Text("Gönder")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .onAppear{
            userInfo.getInfos()
        }
        .alert(item:$alertType){ type in
            switch type {
            case .showAlert:
                return Alert(title: Text(titleInput), message: Text(messageInput), dismissButton: .default(Text("Tamam")){
                })
            case .confirmAlert:
                return Alert(title: Text(titleInput), message: Text(messageInput),
                             primaryButton: .default(Text(button1)){
                           if button=="cancel" {
                               comment=""
                               selectedPoint="Lütfen puan seçiniz"
                           } else if button=="send" {
                               commentViewModel.sendComment(placeName: placeName, comment: comment, score: selectedPoint, fullName: userInfo.firstName+" "+userInfo.lastName)
                               show.toggle()
                           }
                       },
                             secondaryButton: .default(Text(button2)))
            }
        }
        .fullScreenCover(isPresented: $show) {
            CustomerHomeView()
        }
    }
}
