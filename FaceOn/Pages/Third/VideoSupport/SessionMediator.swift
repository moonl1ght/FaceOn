//
//  SessionMediator.swift
//  FaceOn
//
//  Created by Valery Kokanov on 01.06.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import Foundation
import AVFoundation
import Combine
import CoreVideo

final class SessionMediator {
    typealias BufferHandler = (CMSampleBuffer) -> Void
    
    init(
        permissions: Permissions = .init(),
        deviceProvider: DeviceProvider = .init()
    ) {
        self.permissions = permissions
        self.deviceProvider = deviceProvider
    }
    
    private let permissions: Permissions
    private let deviceProvider: DeviceProvider
    
    private let workingQueue = DispatchQueue(
        label: "com.FaceOn.SessionMediator-queue",
        qos: .userInitiated
    )
    
    private var cancallables = Set<AnyCancellable>()
    
    private lazy var delegate = Delegate()
    
    private(set) lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        session.usesApplicationAudioSession = true
        session.automaticallyConfiguresApplicationAudioSession = false
        return session
    }()
    
    private let audioSession = AVAudioSession.sharedInstance()
    
    private lazy var videDataOutput: AVCaptureVideoDataOutput = {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(delegate, queue: .main)
        output.alwaysDiscardsLateVideoFrames = true
        return output
    }()
    
    private lazy var audioDataOutput: AVCaptureAudioDataOutput = {
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(delegate, queue: .main)
        return output
    }()
}

extension SessionMediator {
    func setup(_ callback: @escaping () -> Void) {
        typealias Devices = (videoDevice: AVCaptureDeviceInput, audioDevice: AVCaptureDeviceInput)
        
        let permissionsChecking = permissions.checkVideo()
        .flatMap { self.permissions.checkAudio() }
        .mapError { Error.permissionsCheckingFailure($0) }

        let vieoDeviceProviding = deviceProvider.createVideoDevice()
        .publisher
        .mapError { Error.deviceProvidingFailure($0) }
        
        let audioDeviceProviding = deviceProvider.createAudioDevice()
        .publisher
        .mapError { Error.deviceProvidingFailure($0) }
        
        let devicesSource = Publishers.Zip(
            vieoDeviceProviding,
            audioDeviceProviding
        )
        .tryMap { pair -> Devices in
            (try AVCaptureDeviceInput(device: pair.0), try AVCaptureDeviceInput(device: pair.1))
        }
        .mapError { Error.capturingDeviceCreationFailure($0) }
        
        let source = permissionsChecking.flatMap { devicesSource }
        
        let subscriber = AnySubscriber<Devices, Error>.init(
            receiveSubscription: { subscription in
                subscription.store(in: &self.cancallables)
                subscription.request(.max(1))
            },
            receiveValue: { devices -> Subscribers.Demand in
                self.configureCaptureSession(with: devices.videoDevice, and: devices.audioDevice, callback)
                try! self.configureAudioSession()
                return .none
            },
            receiveCompletion: { completion in
                if case let .failure(error) = completion { print("ERROR: \(error)") }
            }
        )
        
        source.subscribe(subscriber)
        
        delegate.buffersSubject
        .filter { $0.output === self.videDataOutput }
        .map(\.sampleBuffer)
        .sink(receiveValue: processVideoBuffer)
        .store(in: &cancallables)
        
        delegate.buffersSubject
        .filter { $0.output === self.audioDataOutput }
        .map(\.sampleBuffer)
        .sink(receiveValue: processAudioBuffer(_:))
        .store(in: &cancallables)
        
        delegate.buffersSubject
        .map(\.connection)
        .sink(receiveValue: processConnection(_:))
        .store(in: &cancallables)
    }
    
    func startCapturing() {
        guard
            session.isRunning == false,
            session.isInterrupted == false
        else { return }

        workingQueue.async { [session] in
            session.startRunning()
        }
    }
    
    func stopCapturing() {
        guard
            session.isRunning == true,
            session.isInterrupted == false
        else { return }
        
        workingQueue.async { [session] in
            session.stopRunning()
        }
    }
}

private extension SessionMediator {
    func configureCaptureSession(
        with videoDevice: AVCaptureDeviceInput,
        and audioDevice: AVCaptureDeviceInput,
        _ callback: @escaping () -> Void
    ) {
        session.beginConfiguration()
        
        if session.canAddInput(videoDevice) { session.addInput(videoDevice) }
        if session.canAddInput(audioDevice) { session.addInput(audioDevice) }
        
        if session.canAddOutput(videDataOutput) { session.addOutput(videDataOutput) }
        if session.canAddOutput(audioDataOutput) { session.addOutput(audioDataOutput) }
        
        session.commitConfiguration()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            callback()
        }
    }
    
    func configureAudioSession() throws {
        try audioSession.setCategory(.record, mode: .videoRecording, options: .mixWithOthers)
        try audioSession.setActive(true)
    }
    
    func processConnection(_ connection: AVCaptureConnection) {}
    
    func processVideoBuffer(_ buffer: CMSampleBuffer) {
        print("video buffer received \(buffer)")
    }
    
    func processAudioBuffer(_ buffer: CMSampleBuffer) {
        print("audio buffer received \(buffer.totalSampleSize)")
    }
}

private extension SessionMediator {
    final class Delegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
        let buffersSubject = PassthroughSubject<Event, Never>()
        
        func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection
        ) {
            let event = Event(output: output, sampleBuffer: sampleBuffer, connection: connection)
            buffersSubject.send(event)
        }
    }
    
    struct Event {
        let output: AVCaptureOutput
        let sampleBuffer: CMSampleBuffer
        let connection: AVCaptureConnection
    }
    
    enum Error: LocalizedError {
        case capturingDeviceCreationFailure(Swift.Error)
        case configuringAudioSessionFailure(Swift.Error)
        case permissionsCheckingFailure(Permissions.Error)
        case deviceProvidingFailure(DeviceProvider.Error)
    }
}
