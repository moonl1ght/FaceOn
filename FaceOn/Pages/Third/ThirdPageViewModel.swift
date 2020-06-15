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
    
    lazy var action: (Bool) -> Void = { inProgress in
        let source = self.progressPublisher.makeConnectable().autoconnect()
        
        let progressSource = source.assign(to: \.recordingProgress, on: self)
        
        let startingSource = source.prefix(1).handleEvents(
            receiveCancel: { print("finish record") }
        )
        .sink(receiveValue: { _ in print("start record") })
        
        if inProgress == false {
            self.cancallables.remove(startingSource)
            self.cancallables.remove(progressSource)
        } else {
            startingSource.store(in: &self.cancallables)
            progressSource.store(in: &self.cancallables)
        }
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
    }
    
    func stop() {
        runner.stopRunning()
    }
    
    func rotate() {
        configurator.changeCamera()
    }
}
