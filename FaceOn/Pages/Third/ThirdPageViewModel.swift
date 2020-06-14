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
    let sessionProvider: SessionProvider
    
    init(
        _ configurator: SessionConfigurator = .init()
    ) {
        sessionProvider = configurator
        runner = .init(configurator)
        recorder = .init(configurator)
        self.configurator = configurator
    }

    private let recorder: Recorder
    private let runner: Runner
    private let configurator: Configurable

    private lazy var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var cancallables = Set<AnyCancellable>()
}

extension ThirdPageViewModel {
    func run() {
        configurator.configure { [runner] in
            runner.startRunning()
        }
    }
    
    func stop() {
        runner.stopRunning()
    }
}
