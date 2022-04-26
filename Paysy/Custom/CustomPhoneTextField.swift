//
//  CustomPhoneTextField.swift
//  Paysy
//
//  Created by Anıl Demirci on 21.04.2022.
//

import SwiftUI

struct CustomPhoneTextField: View {
    var body: some View {
        PhoneNumberTextField()
    }
}

struct CustomPhoneTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomPhoneTextField()
    }
}


struct CountryCodes: View{
    @Binding var countryCode : String
    @Binding var countryFlag : String
    @Binding var y : CGFloat
    
    var body: some View {
            GeometryReader { geo in
                List(countryDictionary.sorted(by: <), id: \.key) { key , value in
                    HStack {
                        Text("\(self.flag(country: key))")
                        Text("\(self.countryName(countryCode: key) ?? key)")
                        Spacer()
                        Text("+\(value)").foregroundColor(.secondary)
                    }.background(Color.white)
                        .font(.system(size: 20))
                        .onTapGesture {
                            self.countryCode = value
                            self.countryFlag = self.flag(country: key)
                            withAnimation(.spring()) {
                                self.y = 150
                            }
                    }
                }
                .padding(.bottom)
                .frame(width: geo.size.width, height: 300)
                .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).maxY - 150)
                
            }
        }
    
    func countryName(countryCode: String) -> String? {
            let current = Locale(identifier: "en_US")
            return current.localizedString(forRegionCode: countryCode)
        }
    
    func flag(country:String) -> String {
            let base : UInt32 = 127397
            var flag = ""
            for v in country.unicodeScalars {
                flag.unicodeScalars.append(UnicodeScalar(base + v.value)!)
            }
            return flag
        }
    
}

struct PhoneNumberTextField : View {
    @State var phoneNumber = ""
    @State var y : CGFloat = 150
    @State var countryCode = ""
    @State var countryFlag = ""
    
    var body: some View {
            ZStack {
                HStack (spacing: 0) {
                    Text(countryCode.isEmpty ? "🇦🇺 +61" : "\(countryFlag) +\(countryCode)")
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundColor(countryCode.isEmpty ? .secondary : .black)
                        .onTapGesture {
                            withAnimation (.spring()) {
                                self.y = 0
                            }
                    }
                    TextField("Phone Number", text: $phoneNumber)
                        .frame(height: UIScreen.main.bounds.height * 0.020)
                        .padding()
                        .keyboardType(.phonePad)
                }
                CountryCodes(countryCode: $countryCode, countryFlag: $countryFlag, y: $y)
                    .offset(y: y)
                
            }
    }
}

