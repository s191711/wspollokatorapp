//
//  PasswordAlert.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 13/11/2021.
//

import SwiftUI

struct PasswordAlert: View {
    private let screenSize = UIScreen.main.bounds
    
    @Binding var isShown: Bool
    @Binding var oldPass : String
    @Binding var newPass: String
    var onDone: () -> Void = {}
    var onCancel: () -> Void = {}
    
        var body: some View {
            VStack {
                HStack {
                    Text("Stare hasło: ")
                    SecureField("", text: $oldPass)
                        .background(.white)
                }
                HStack {
                    Text("Nowe hasło: ")
                    SecureField("", text: $newPass)
                        .background(.white)
                }
                HStack {
                    Text("Powtórz hasło: ")
                    SecureField("", text: $newPass)
                        .background(.white)
                }
                Spacer()
                HStack(spacing: 40) {
                    Button {
                        self.onDone()
                    } label : {
                        Text("Zmień hasło")
                    }
                    Button {
                        self.isShown = false
                        self.onCancel()
                    } label : {
                        Text("Anuluj")
                    }
                }
            }
            .padding()
            .frame(width: screenSize.width * 0.85, height: screenSize.height * 0.2)
            .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                    .offset(y: isShown ? 0 : screenSize.height)
                    .animation(.spring())
                    .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
        }
}
struct PasswordAlert_Previews: PreviewProvider {
    static var previews: some View {
        PasswordAlert(isShown: .constant(true), oldPass: .constant(""), newPass: .constant(""), onDone: {}, onCancel: {})
    }
}
