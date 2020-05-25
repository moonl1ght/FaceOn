//
//  ContentView.swift
//  Talkit
//
//  Created by Valery Kokanov on 18.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 81)

                FirstPageView().environmentObject(FirstPageViewModel())
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.offWhite)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
