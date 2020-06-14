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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            content
        }
        .onAppear {
            self.viewModel.run()
        }
        .onDisappear {
            self.viewModel.stop()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 2) {
            Spacer(minLength: 60)
            
            HStack(alignment: .top) {
                PageTitleView(title: "3. record a video".uppercased())
                .frame(maxWidth: 290)
                
                Spacer()
            }
            
            Spacer(minLength: 20)
            
            PreviewViewControllerWrapper(viewModel.sessionProvider)
            .frame(height: 322)
            .cornerRadius(38)
            .shadow(radius: 10)
            .padding()
            
            HStack(alignment: .center) {
                Text("Rotate")
                Spacer()
                Text("mp4")
                Text("gif")
            }
            .padding([.leading, .trailing, .top])
            
            
            CircleProgress(progress: .constant(0.0))
            .frame(width: 132)
            
            HStack {
                Button(
                    action: { self.presentationMode.wrappedValue.dismiss() }
                ) {
                    UnerlinedText(text: "Back".uppercased())
                }
                
                Spacer()
                
                NavigationLink(destination: EmptyView()) {
                    UnerlinedText(text: "Next".uppercased())
                }
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
    }
}

struct ThirdPageView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPageView(viewModel: .init())
    }
}
