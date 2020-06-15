//
//  SessionConfigurator.swift
//  FaceOn
//
//  Created by Valery Kokanov on 13.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

protocol Configurable: AnyObject {
    typealias ConfigurationCompletionHandler = () -> Void
    
    var isConfigured: Bool { get }
    
    func configure(_ completionHandler: @escaping ConfigurationCompletionHandler)
    func changeCamera()
}

final class SessionConfigurator: Configurable, OutputProvider, SessionProvider {
    typealias Inputs = (video: AVCaptureDeviceInput, audio: AVCaptureDeviceInput)

    init(
        permissions: Permissions = .init(),
        deviceProvider: DeviceProvider = .init()
    ) {
        self.permissions = permissions
        self.deviceProvider = deviceProvider
    }
    
    private let deviceProvider: DeviceProvider
    private let permissions: Permissions
    
    private var state: State = .initial
    private var cancellables = Set<AnyCancellable>()
    private var currentCameraType: CurrentCameraType = .back

    private(set) var isConfigured = false
    private(set) lazy var output = AVCaptureMovieFileOutput()
    private(set) lazy var session = AVCaptureSession()
}

extension SessionConfigurator {
    func configure(_ completionHandler: @escaping ConfigurationCompletionHandler) {
        guard isConfigured == false else { return completionHandler() }
        
        checkPermissions().flatMap { self.createDevices() }
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .sink(
            receiveCompletion: { result in
                if case let .failure(reason) = result {
                    print(reason)
                }
            },
            receiveValue: {
                self.removeVideoInput()
                self.configureSession(with: $0, completionHandler: completionHandler)
                self.isConfigured.toggle()
            }
        )
        .store(in: &cancellables)
    }
    
    func changeCamera() {
        cancellables.removeAll(keepingCapacity: true)
        isConfigured = false
        currentCameraType.toggle()
        
        self.configure {}
    }
}

private extension SessionConfigurator {
    func checkPermissions() -> AnyPublisher<Void, Error> {
        Publishers.Zip(permissions.checkVideo(), permissions.checkAudio()).map { _ in }
        .mapError { Error.permissionsCheckingFailure($0) }
        .handleEvents(
            receiveCompletion: {
                if case .failure = $0 {
                    self.state = .notAuthorized
                }
            }
        )
        .eraseToAnyPublisher()
    }
    
    func createDevices() -> AnyPublisher<Inputs, Error> {
        let position = currentCameraType.asAVPosition()
        let videoSource = deviceProvider.createVideoDevice(with: position).publisher
        let audioSource = deviceProvider.createAudioDevice().publisher
        
        return Publishers.Zip(videoSource, audioSource)
        .mapError { Error.deviceProvidingFailure($0) }
        .tryMap { (try AVCaptureDeviceInput(device: $0.0), try AVCaptureDeviceInput(device: $0.1)) }
        .mapError { Error.capturingDeviceCreationFailure($0) }
        .eraseToAnyPublisher()
    }
    
    func configureSession(with inputs: Inputs, completionHandler: ConfigurationCompletionHandler) {
        session.beginConfiguration()
        
        if session.canAddInput(inputs.video) {
            session.addInput(inputs.video)
        }
        if session.canAddInput(inputs.audio) {
            session.addInput(inputs.audio)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
            if
                let connection = output.connection(with: .video),
                connection.isVideoStabilizationSupported
            {
                connection.preferredVideoStabilizationMode = .auto
            }
        }

        session.commitConfiguration()
        
        completionHandler()
    }
    
    func removeVideoInput() {
        guard
            session.inputs.isEmpty == false,
            let input = (
                session.inputs
                .lazy
                .compactMap { $0 as? AVCaptureDeviceInput }
                .first(
                    where: {
                        $0.device.deviceType == .builtInDualCamera ||
                        $0.device.deviceType == .builtInTrueDepthCamera
                    }
                )
            )
        else { return }
        session.beginConfiguration()
        session.removeInput(input)
        session.commitConfiguration()
    }
}

private extension SessionConfigurator {
    enum State {
        case initial
        case running
        case stopped
        case notAuthorized
    }
    
    enum CurrentCameraType: Int {
        case back = 1
        case front
        
        mutating func toggle() {
            self = self == .back ? .front : .back
        }
        
        func asAVPosition() -> AVCaptureDevice.Position {
            AVCaptureDevice.Position(rawValue: self.rawValue) ?? .unspecified
        }
    }
    
    enum Error: LocalizedError {
        case capturingDeviceCreationFailure(Swift.Error)
        case configuringAudioSessionFailure(Swift.Error)
        case permissionsCheckingFailure(Permissions.Error)
        case deviceProvidingFailure(DeviceProvider.Error)
    }
}
