//
//  VideoProcessor.swift
//  FaceOn
//
//  Created by Valery Kokanov on 01.06.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

final class VideoProcessor {
    init(
        mediator: SessionMediator
    ) {
        self.mediator = mediator
    }
    
    func configure(_ callback: @escaping () -> Void) {
        mediator.setup(callback)
    }
    
    func startCapturing() {
        mediator.startCapturing()
    }
    
    func stopCapturin() {
        mediator.stopCapturing()
    }
    
    private let mediator: SessionMediator
}
