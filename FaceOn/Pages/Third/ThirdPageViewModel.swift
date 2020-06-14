//
//  ThirdPageViewModel.swift
//  FaceOn
//
//  Created by Valery Kokanov on 28.05.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import Combine
import SwiftUI
import AVFoundation

final class ThirdPageViewModel: ObservableObject {
    let sessionProvider: SessionProvider
    
    let action: (Bool) -> Void = { inProgress in
        print(inProgress)
    }
    
    @Published var recordingProgress: Float
    
    init(
        _ configurator: SessionConfigurator = .init()
    ) {
        sessionProvider = configurator
        runner = .init(configurator)
        recorder = .init(configurator)
        self.configurator = configurator
        recordingProgress = 0
    }

    private let recorder: Recorder
    private let runner: Runner
    private let configurator: Configurable

    private lazy var timerPublisher = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    private var cancallables = Set<AnyCancellable>()
    
    private var progressPublisher: AnyPublisher<Float, Never> {
        var progress = 0
        let limit = 150
        
        return timerPublisher
        .prefix(limit)
        .map { _ in }
        .handleEvents(
            receiveOutput: { progress += 1 }
        )
        .map { Float((progress * 100) / limit) / 100 }
        .eraseToAnyPublisher()
    }
}

extension ThirdPageViewModel {
    func run() {
        configurator.configure { [runner] in
            runner.startRunning()
        }
        
        progressPublisher.sink(
            receiveCompletion: { _ in print("stop") },
            receiveValue: { self.recordingProgress = $0 }
        )
        .store(in: &cancallables)
    }
    
    func stop() {
        runner.stopRunning()
    }
}
