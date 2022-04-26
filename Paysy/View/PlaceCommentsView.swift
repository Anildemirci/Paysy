//
//  PlaceCommentsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct PlaceCommentsView: View {
    var body: some View {
        VStack{
            List(comments){i in
                VStack(alignment: .leading,spacing: 10){
                    HStack{
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        Text(i.name)
                            .font(.subheadline)
                        Spacer()
                        Text("Puan \(i.point)")
                            .font(.subheadline)
                    }
                    Text(i.date)
                        .font(.footnote)
                    Text(i.comment)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }.background(Color("back"))
            }.listStyle(.plain)
        }
        .navigationTitle("Yorumlar").navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaceCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCommentsView()
    }
}
