//
//  ThirdPageViewModel.swift
//  FaceOn
//
//  Created by Valery Kokanov on 28.05.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import Combine
import AVFoundation

final class ThirdPageViewModel: ObservableObject {
    @Published var isConfigured = false
    let mediator: SessionMediator
    
    init(
        mediator: SessionMediator = .init()
    ) {
        self.mediator = mediator
    }
    
    func configure() {
        guard isConfigured == false else { return }
    }
}
