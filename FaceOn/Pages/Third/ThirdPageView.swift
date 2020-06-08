//
//  ThirdPageView.swift
//  FaceOn
//
//  Created by Valery Kokanov on 28.05.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import SwiftUI

struct ThirdPageView: View {
    @ObservedObject var viewModel: ThirdPageViewModel
    
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            content
        }
        //.navigationBarBackButtonHidden(true)
        //.navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 50) {
            HStack(alignment: .top) {
                PageTitleView(title: "3. record a video".uppercased())
                .frame(maxWidth: 290)
                
                Spacer()
            }
            
            PreviewViewControllerWrapper(mediator: viewModel.mediator)
            .frame(width: 322, height: 322, alignment: .center)
            .cornerRadius(38)
            .shadow(radius: 10)
            
            Spacer()
        }
    }
}

struct ThirdPageView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPageView(viewModel: .init())
    }
}
