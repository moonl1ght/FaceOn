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
        VStack(alignment: .center) {
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
                rotateButton
                Spacer()
                Text("mp4")
                Text("gif")
            }
            .padding([.leading, .trailing, .top])
            
            
            CircleProgressWithButton(
                action: self.viewModel.action,
                progress: self.$viewModel.recordingProgress
            )
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
    
    private var rotateButton: some View {
        Button(action: viewModel.rotate) {
            Image(systemName: "arrow.2.squarepath")
            .resizable()
            .frame(width: 30, height: 20)
        }
        .foregroundColor(.black)
    }
}

struct ThirdPageView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPageView(viewModel: .init())
    }
}
