//
//  ChangeCameraButton.swift
//  FaceOn
//
//  Created by Valery Kokanov on 15.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct ChangeCameraButton: View {
    let action: () -> Void
    
    @State private var isRotated = false
    
    var body: some View {
        Button(
            action: {
                self.isRotated.toggle()
                self.action()
            }
        ) {
            Image(systemName: "arrow.2.squarepath")
            .resizable()
            .frame(width: 30, height: 20)
        }
        .foregroundColor(.black)
        .rotationEffect(.degrees(isRotated ? 90 : 0))
        .animation(.linear)
    }
}

struct ChangeCameraButton_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCameraButton { }
    }
}
