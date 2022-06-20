//
//  BusinessComments.swift
//  Paysy
//
//  Created by Anıl Demirci on 17.06.2022.
//

import SwiftUI

struct BusinessComments: View {
    @State private var showEdit=false
    
    var body: some View {
        CustomEditButton(show: $showEdit)
        NavigationLink(destination: EditBusinessComments()) {
            Text("Düzenle")
        }
        Text("Comments")
    }
}

struct BusinessComments_Previews: PreviewProvider {
    static var previews: some View {
        BusinessComments()
    }
}

struct EditBusinessComments: View {
    var body: some View {
        VStack{
            Text("yorum düzenle")
        }
    }
}
