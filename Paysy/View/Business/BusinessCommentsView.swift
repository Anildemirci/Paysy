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
    
    var body: some View {
        VStack{
            CommentStructView()
                .navigationBarItems(trailing:
                                        Button(action: {
                    show.toggle()
                }){
                    Text("Yorum Yap")
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
    
    var body: some View {
        VStack{
            Spacer()
            Text("5 müşteri oyu ile 4.5 puan.").padding()
                .border(Color.black, width: 2)
            List(){
                VStack{
                    HStack(alignment:.top){
                        VStack(alignment: .leading){
                            Text("Anıl Demirci")
                            Text("15.03.2022")
                        }
                        Spacer()
                        Group {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }.foregroundColor(Color.yellow)
                    }
                    Spacer()
                    Text("Mekanı çok beğendim.")
                }
                VStack{
                    HStack(alignment:.top){
                        VStack(alignment: .leading){
                            Text("Anıl Demirci")
                            Text("15.03.2022")
                        }
                        Spacer()
                        Group {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }.foregroundColor(Color.yellow)
                    }
                    Spacer()
                    Text("Ortalama bir mekan.")
                }
                VStack{
                    HStack(alignment:.top){
                        VStack(alignment: .leading){
                            Text("Anıl Demirci")
                            Text("15.03.2022")
                        }
                        Spacer()
                        Group {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }.foregroundColor(Color.yellow)
                    }
                    Spacer()
                    Text("Fiyatlar çok pahalı.")
                }
            }.listStyle(.plain)
        }
    }
}

struct EditBusinessComments: View {
    @State private var show=false
    
    var body: some View {
        VStack{
            CustomDismissButton(show: $show)
            Text("yorum düzenle")
            Spacer()
        }
        .fullScreenCover(isPresented: $show) { () -> BusinessAccountView in
            return BusinessAccountView()
        }
    }
}
