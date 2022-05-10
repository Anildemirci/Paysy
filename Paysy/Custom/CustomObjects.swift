//
//  CustomObjects.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import Foundation
import SwiftUI

//dismiss butonu (X)
struct CustomDismissButton : View{
    @Binding var show:Bool
    var body: some View{
        HStack{
            Spacer()
            Button(action: {
                show.toggle()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding()
                    
            }
        }.frame(height: 25)
    }
}

//sayfaları gösteriyor
struct CustomTabIndicator: View {
    var count: Int
    @Binding var current: Int
    
    var body: some View {
        HStack{
            ForEach(0..<count,id:\.self){i in
                ZStack{
                    if(current)==i {
                        Circle().fill(Color.blue)
                    } else {
                        Circle()
                            .fill(Color.white)
                            .overlay(
                                Circle()
                                    .stroke(Color.black,lineWidth: 1.5)
                            )
                    }
                }.frame(width: 10, height: 10)
            }
        }
        Spacer()
    }
}

struct CustomLoadingView : View {
    
    @State var animation = false
    
    var body: some View {
        VStack{
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.red,lineWidth: 8)
                .frame(width: 75, height: 75)
                .rotationEffect(.init(degrees: animation ? 360 : 0))
                .padding(50)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all,edges: .all))
        .onAppear(perform: {
            withAnimation(Animation.linear(duration: 1)) {
                animation.toggle()
            }
        })
    }
}

