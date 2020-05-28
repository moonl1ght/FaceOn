//
//  FirstPageView.swift
//  Talkit
//
//  Created by Valery Kokanov on 21.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct FirstPageView: View {
    @ObservedObject var viewModel: FirstPageViewModel
    
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
                .edgesIgnoringSafeArea([.leading, .trailing])
                
                NeumorphicPlusButton(systemImageName: "plus", buttonInnerPadding: 30) {}
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                NavigationLink(destination: ThirdPageView(viewModel: .init())) {
                    UnerlinedText(text: "Next".uppercased())
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct FirstPageView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView(viewModel: .init())
    }
}
