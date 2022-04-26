//
//  CreditCardsView.swift
//  Paysy
//
//  Created by Anıl Demirci on 15.04.2022.
//

import SwiftUI

struct CreditCardsView: View {
    
    @State var showAddCard=false
    @State var navigationBar=false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 25){
                AnimationCardView(navigationBar: $navigationBar)
            }
            .navigationTitle("Kredi Kartları").navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
            })
            .navigationBarHidden(navigationBar)
                .navigationBarItems(trailing: Button(action: {
                    showAddCard.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
            })
                .fullScreenCover(isPresented: $showAddCard) {
                    AddCard(showAddCard: $showAddCard)
                }
        }
    }
}

struct CreditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardsView()
    }
}

struct AnimationCardView: View{
    
    @Binding var navigationBar: Bool
    @State var startAnimation = false
    @State var startCardRotation = false
    @State var selectedCard: Card = Card(cardName: "",cardHolder: "", cardNumber: "", cardValidity: "", cardImage: "")
    @State var cardAnimation = false
    @Namespace var animation
    
    @Environment(\.colorScheme) var colorSCheme
    
    var body: some View{
        ScrollView{
            VStack{
                ZStack{
                    //ilk üç kartı gösteriyor.
                    ForEach(cards.indices.reversed(),id: \.self){ index in
                        CardView(card: cards[index])
                            .scaleEffect(selectedCard.id == cards[index].id ? 1 : index == 0 ? 1 : 0.9)
                            .rotationEffect(.init(degrees: startAnimation ? 0 : index == 1 ? -15 : (index == 2 ? 15 : 0)))
                            
                            .onTapGesture {
                                animateView(card: cards[index])
                                navigationBar.toggle()
                                
                            }.ignoresSafeArea(.all)
                            .offset(y: startAnimation ? 0 : index==1 ? 60 : (index == 2 ? -60 : 0))
                            .matchedGeometryEffect(id: "CARD_ANIMATION", in: animation)
                            .rotationEffect(.init(degrees: selectedCard.id == cards[index].id && startCardRotation ? -90 : 0))
                        
                            .zIndex(selectedCard.id==cards[index].id ? 1000:0)
                            .opacity(startAnimation ? selectedCard.id == cards[index].id ? 1 : 0 : 1)
                    }
                }
                .rotationEffect(.init(degrees: 90))
                .frame(width: UIScreen.main.bounds.width-30)
                .scaleEffect(0.8)
                .padding(.top,20)
                Spacer(minLength: 35)
                
                Text("Tüm Kartlar").font(.title3).fontWeight(.bold)
                
                ForEach(cards){i in
                    HStack{
                        VStack(alignment: .leading){
                            Text(i.cardName)
                            Text(i.cardNumber)
                        }
                        Spacer()
                        Image(systemName: "creditcard")
                    }
                    Divider()
                }
            }
            .ignoresSafeArea()
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.04))
            .blur(radius: cardAnimation ? 100 : 0)
            .overlay(
                ZStack(alignment: .topTrailing, content: {
                    if cardAnimation{
                        HStack{
                            Button(action :{
                                //kartı sil
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size:18,weight: .bold))
                                    .foregroundColor(colorSCheme != .dark ? .white : .black)
                                    .padding()
                                    .background(Color.primary)
                                    .clipShape(Circle())
                            }
                            Spacer()
                            Button(action: {
                                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)){
                                    startCardRotation=false
                                    selectedCard=Card(cardName: "",cardHolder: "", cardNumber: "", cardValidity: "", cardImage: "")
                                    cardAnimation=false
                                    startAnimation=false
                                    navigationBar.toggle()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size:18,weight: .bold))
                                    .foregroundColor(colorSCheme != .dark ? .white : .black)
                                    .padding()
                                    .background(Color.primary)
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        CardView(card: selectedCard)
                            .matchedGeometryEffect(id: "CARD_ANIMATION", in: animation)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                })
            )
    }
    
    func animateView(card: Card){
        
        selectedCard=card
        
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
            startAnimation=true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            withAnimation(.spring()){
                startCardRotation=true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
            withAnimation(.spring()){
                cardAnimation=true
            }
        }
    }
}

struct CardView: View{
    var card: Card
    var body: some View{
        Image(card.cardImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        VStack(alignment: .leading, spacing: 10){
            Text(card.cardNumber)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .offset(y: 35)
            Spacer()
            HStack{
                VStack(alignment: .leading, spacing: 4, content: {
                    Text("Kart Sahibi")
                        .fontWeight(.semibold)
                    Text(card.cardHolder)
                        .font(.title2)
                        .fontWeight(.bold)
                })
                Spacer(minLength: 10)
                VStack(alignment: .leading, spacing: 4, content: {
                    Text("VALID THRU")
                        .fontWeight(.semibold)
                    Text(card.cardValidity)
                        .font(.title2)
                        .fontWeight(.bold)
                })
            }
            .foregroundColor(.black)
        }
        .padding()
    }
}

struct AddCard: View{
    @State var cardName=""
    @State var cardNumber=""
    @State var cardHolder=""
    @State var cardExpiry=""
    @State var CVV=""
    @State var cardSide = "creditcard"
    @Binding var showAddCard: Bool
    
    var body: some View {
        
        VStack{
             
            CustomDismissButton(show: $showAddCard)
            
            ScrollView(.vertical, showsIndicators: false) {
                Image(systemName: cardSide)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3)
                if cardSide == "creditcard" {
                    Text(cardNumber)
                        .fontWeight(.bold)
                        .offset(y: -90)
                    Text(cardExpiry)
                        .fontWeight(.bold)
                        .offset(y: -90)
                    Text(cardHolder)
                        .fontWeight(.bold)
                        .offset(x:-100 ,y: -90)
                } else {
                    Text(CVV)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .offset(y: -90)
                }
                Group {
                    TextField("kayıt adı", text: $cardName)
                        .padding()
                        .autocapitalization(.words)
                        .keyboardType(.namePhonePad)
                        .onTapGesture {
                            cardSide="creditcard"
                        }
                    TextField("kart numarası", text: $cardNumber)
                        .padding()
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            cardSide="creditcard"
                        }
                    TextField("kart sahibi", text: $cardHolder)
                        .padding()
                        .autocapitalization(.allCharacters)
                        .onTapGesture {
                            cardSide="creditcard"
                        }
                    TextField("son kullanma tarihi", text: $cardExpiry)
                        .padding()
                        .keyboardType(.numbersAndPunctuation)
                        .onTapGesture {
                            cardSide="creditcard"
                        }
                    TextField("CVV", text: $CVV)
                        .padding()
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            cardSide="creditcard.fill"
                        }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.08 )
                .overlay(Rectangle().stroke(Color.black,lineWidth:3))
                .cornerRadius(5)
                Spacer(minLength: 25)
                Button(action : {
                    //kartı ekle
                }) {
                    //Image(systemName: "plus")
                    Text("Ekle")
                        .font(.system(size:18,weight: .bold))
                        .frame(width: UIScreen.main.bounds.width * 0.5 , height: UIScreen.main.bounds.height * 0.015)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .clipShape(Capsule())
                }
            }.padding()
        }
    }
}


