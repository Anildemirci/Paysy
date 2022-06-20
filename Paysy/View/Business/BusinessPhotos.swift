//
//  BusinessPhotos.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI

struct BusinessPhotos: View {
    @State private var showEdit=false
    var body: some View {
        VStack{
            CustomEditButton(show: $showEdit)
            Text("Photos")
        }
    }
}

struct BusinessPhotos_Previews: PreviewProvider {
    static var previews: some View {
        BusinessPhotos()
    }
}
