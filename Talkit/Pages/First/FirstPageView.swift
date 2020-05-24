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
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .top) {
                PageTitleView(title: "1. select an image".uppercased())
                .frame(maxWidth: 290)
                
                Spacer()
            }
            
            ImagesList(images: self.viewModel.images) {
                print($0)
            }
            .padding()
            
            plusButton
            
            Spacer()
        }
    }
    
    var plusButton: some View {
        Text("plus here")
    }
}

struct FirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView()
    }
}
