//
//  PageTitleView.swift
//  Talkit
//
//  Created by Valery Kokanov on 23.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct PageTitleView: View {
    var title: String
    
    var body: some View {
        ZStack {
            Color.yellow
            .opacity(0.8)
            .frame(
                maxHeight: 20,
                alignment: .bottom
            )
            .offset(y: 10)
            
            Text(self.title)
            .lineLimit(1)
            .truncationMode(.tail)
            .font(Font.title.bold())
            .frame(
                alignment: .center
            )
        }
    }
}

struct PageTitleView_Previews: PreviewProvider {
    static var previews: some View {
        PageTitleView(title: "1. select an image".uppercased())
    }
}
