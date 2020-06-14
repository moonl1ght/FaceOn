//
//  Runner.swift
//  FaceOn
//
//  Created by Valery Kokanov on 13.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import AVFoundation

protocol SessionProvider: AnyObject {
    var session: AVCaptureSession { get }
}

final class Runner {
    init(_ provider: SessionProvider) {
        session = provider.session
    }
    
    private let session: AVCaptureSession
    
    private let workingQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!)_RunnerQueue")
}

extension Runner {
    func startRunning() {
        guard
            session.isRunning == false,
            session.isInterrupted == false
        else { return }
        workingQueue.async { self.session.startRunning() }
    }
    
    func stopRunning() {
        guard
            session.isRunning == true,
            session.isInterrupted == false
        else { return }
        workingQueue.async { self.session.stopRunning() }
    }
}
