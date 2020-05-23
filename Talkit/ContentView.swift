//
//  ContentView.swift
//  Talkit
//
//  Created by Valery Kokanov on 18.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            FirstPageView().environmentObject(FirstPageViewModel())
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
