//
//  ContentView.swift
//  Paysy
//
//  Created by Anıl Demirci on 12.04.2022.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
        VStack{
            HomeView()
        }.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


