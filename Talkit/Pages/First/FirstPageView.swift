//
//  FirstPageView.swift
//  Talkit
//
//  Created by Valery Kokanov on 21.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct FirstPageView: View {
    @EnvironmentObject var viewModel: FirstPageViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            HStack(alignment: .top) {
                PageTitleView(title: "1. select an image".uppercased())
                .frame(maxWidth: 290)
                
                Spacer()
            }
            
            VStack(alignment: .center, spacing: 21) {
                ImagesList(images: self.viewModel.images) {
                    print($0)
                }
                
                NeumorphicPlusButton(systemImageName: "plus", buttonInnerPadding: 30) {}
            }
            .padding()
            
            Spacer()
        }
    }
}

struct FirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView()
    }
}
