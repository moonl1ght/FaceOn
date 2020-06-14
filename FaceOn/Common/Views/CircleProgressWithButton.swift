//
//  CircleProgress.swift
//  FaceOn
//
//  Created by Valery Kokanov on 13.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct CircleProgressWithButton: View {
    let action: (Bool) -> Void
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                self.circle
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                
                self.circle
                
                RoundedButton(action: self.action)
                .frame(
                    width: geometry.frame(in: .local).width.advanced(by: -20)
                )
                .position(
                    x: geometry.frame(in: .local).midX,
                    y: geometry.frame(in: .local).midY
                )
            }
        }
    }
    
    private var circle: some View {
        Circle()
        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
        .stroke(
            style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .bevel)
        )
        .fill(Color.offWhite)
        .rotationEffect(Angle(degrees: 270))
        .animation(.linear)
    }
}

struct CircleProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressWithButton(action: { _ in }, progress: .constant(0.9))
        .frame(width: 132, alignment: .center)
    }
}
