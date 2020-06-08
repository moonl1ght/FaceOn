//
//  UnerlinedText.swift
//  FaceOn
//
//  Created by Valery Kokanov on 28.05.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import SwiftUI

struct UnerlinedText: View {
    let text: String
    
    var body: some View {
        Text(text).font(Font.title).foregroundColor(.black).italic().bold().underline()
    }
}

struct UnerlinedText_Previews: PreviewProvider {
    static var previews: some View {
        UnerlinedText(text: "example".uppercased())
    }
}
