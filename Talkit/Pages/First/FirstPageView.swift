//
//  FirstPageView.swift
//  Talkit
//
//  Created by Valery Kokanov on 21.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct FirstPageView: View {
    @State var selectedImageName: String?
    @EnvironmentObject var viewModel: FirstPageViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .top) {
                PageTitleView(title: "1. select an image".uppercased())
                .frame(maxWidth: 290)
                
                Spacer()
            }
            
            images.padding()
            
            plusButton
            
            Spacer()
        }
    }
    
    var images: some View {
        Group {
            if viewModel.images.isEmpty == true {
                EmptyView()
            } else {
                VStack(alignment: .center, spacing: 20) {
                    ForEach(0..<viewModel.images.count) { index in
                        HStack(alignment: .center, spacing: 20) {
                            ForEach(0..<self.viewModel.images[index].count) { subindex in
                                Image(
                                    uiImage: self.viewModel.images[index][subindex].1
                                )
                                .resizable()
                                .frame(width: 94, height: 94, alignment: .center)
                                .cornerRadius(15)
                                .shadow(radius: 7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            self.selectedImageName == self.viewModel.images[index][subindex].0 ? Color.yellow : Color.clear,
                                            lineWidth: 7
                                    )
                                )
                                .onTapGesture {
                                    self.selectedImageName = self.viewModel.images[index][subindex].0
                                }
                            }
                        }
                    }
                }
            }
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
