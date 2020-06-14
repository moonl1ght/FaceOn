//
//  NeumorphicPlusButton.swift
//  FaceOn
//
//  Created by Valery Kokanov on 25.05.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import SwiftUI

struct NeumorphicButtonStyle: ButtonStyle {
    let padding: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding(padding)
        .background(
            Group {
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 15)
                    .fill(Color.offWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                        .mask(
                            RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(Color.black, Color.clear))
                        )
                    )
                } else {
                    RoundedRectangle(cornerRadius: 15)
                    .fill(Color.offWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                }
            }
        )
    }
}

struct NeumorphicPlusButton: View {
    let systemImageName: String
    let buttonInnerPadding: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action
        ) {
            Image(systemName: systemImageName)
            .resizable()
            .frame(width: 30, height: 30, alignment: .center)
            .foregroundColor(.black)
        }
        .buttonStyle(NeumorphicButtonStyle(padding: buttonInnerPadding))
    }
}

struct NeumorphicPlusButton_Previews: PreviewProvider {
    static var previews: some View {
        NeumorphicPlusButton(systemImageName: "plus", buttonInnerPadding: 94) {}
    }
}
