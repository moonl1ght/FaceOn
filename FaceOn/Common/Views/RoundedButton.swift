//
//  RoundedButton.swift
//  FaceOn
//
//  Created by Valery Kokanov on 13.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

private struct NeumorphicCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .padding()
        .background(
            Group {
                if configuration.isPressed == true {
                    Circle()
                    .fill(Color.offWhite)
                    .overlay(
                        Circle()
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                        .mask(
                            Circle()
                            .fill(LinearGradient(Color.gray, Color.clear))
                        )
                    )
                } else {
                    Circle()
                    .fill(Color.offWhite)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
                    .shadow(color: Color.white.opacity(0.7), radius: 2, x: -1, y: -1)
                }
            }
        )
    }
}

struct RoundedButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(
            action: action
        ) {
            ZStack {
                Circle()
                .fill(Color.offWhite)
                
                Circle()
                .fill(Color.gray)
                .frame(width: 13)
            }
        }
        .buttonStyle(NeumorphicCircleButtonStyle())
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton {}.frame(width: 130)
    }
}
