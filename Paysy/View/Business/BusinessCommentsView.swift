//
//  BusinessCommentsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 21.06.2022.
//

import SwiftUI

struct BusinessCommentsView: View {
    
    @State private var showEdit=false
    @State private var show=false
    @State var placeName=""
    
    var body: some View {
        VStack{
            CommentStructView(placeName:placeName)
                .navigationBarItems(trailing:
                                        Button(action: {
                    show.toggle()
                }){
                    Text("Yorum Yap")
                        .foregroundColor(Color.white)
                    //Image(systemName: "plus").resizable().frame(width: 25, height: 25).foregroundColor(Color.blue)
                })
        }
        .fullScreenCover(isPresented: $show) { () -> EditBusinessComments in
            return EditBusinessComments()
        }
    }
}

struct BusinessCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessCommentsView()
    }
}

struct CommentStructView:View {
    
    @StateObject private var placeCommentViewModel=CommentViewModel()
    @State var placeName=""
    
    var body: some View {
        VStack{
            if placeCommentViewModel.commentsArrayStruct.count == 0 {
                Text("Henüz yorum yapılmadı.")
            } else {
                let roundedValue=NSString(format: "%.2f",placeCommentViewModel.totalScore)
                Text("\(placeCommentViewModel.commentsArrayStruct.count) müşteri oyu ile \(roundedValue) puan.").padding()
                    .border(Color.black, width: 1)
                List(placeCommentViewModel.commentsArrayStruct){ i in
                    HStack {
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
                        Button(action: {
                            
                        }) {
                            Image(systemName: "bubble.right")
                            .foregroundColor(Color.black)
                            .frame(width: 25, height: 25)
                            .cornerRadius(25)
                        }
                    }
                }.listStyle(.plain)
            }
        }
        .onAppear{
            placeCommentViewModel.getComment(placeName: placeName)
        }
    }
}

struct EditBusinessComments: View {
    @State private var show=false
    
    var body: some View {
        VStack{
            CustomDismissButton(show: $show)
            Text("yorum düzenle")
                .foregroundColor(Color.white)
            Spacer()
        }
        .fullScreenCover(isPresented: $show) { () -> BusinessAccountView in
            return BusinessAccountView()
        }
    }
}
