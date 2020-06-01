//
//  SessionMediator.swift
//  Talkit
//
//  Created by Valery Kokanov on 01.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

final class SessionMediator {
    typealias BufferHandler = (CMSampleBuffer) -> Void
    
    var bufferHandler: BufferHandler? = nil {
        didSet {
            delegate.bufferHandler = bufferHandler
        }
    }
    
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
        label: "com.talkit.SessionMediator-queue",
        qos: .userInitiated
    )
    
    private var cancallables = Set<AnyCancellable>()
    
    private lazy var delegate = Delegate(managingConnection)
    
    private(set) lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.usesApplicationAudioSession = true
        session.automaticallyConfiguresApplicationAudioSession = false
        return session
    }()
    
    private lazy var videDataOutput: AVCaptureVideoDataOutput = {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(delegate, queue: .main)
        output.alwaysDiscardsLateVideoFrames = true
        return output
    }()
}

extension SessionMediator {
    func setup() {
        let permissionsChecking = permissions.checkVideo()
        .mapError { Error.permissionsCheckingFailure($0) }

        let deviceProviding = deviceProvider.createVideoDevice()
        .publisher
        .mapError { Error.deviceProvidingFailure($0) }
        
        let source = permissionsChecking.flatMap { deviceProviding }
        .tryMap { try AVCaptureDeviceInput(device: $0) }
        .mapError { Error.capturingDeviceCreationFailure($0) }
        .subscribe(on: DispatchQueue.main)
        
        let subscriber = AnySubscriber<AVCaptureDeviceInput, Error>.init(
            receiveSubscription: { subscription in
                subscription.store(in: &self.cancallables)
                subscription.request(.max(1))
            },
            receiveValue: { deviceInput -> Subscribers.Demand in
                self.configureSession(with: deviceInput)
                return .none
            },
            receiveCompletion: { completion in
                if case let .failure(error) = completion { print("ERROR: \(error)") }
            }
        )
        
        source.subscribe(subscriber)
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
    func managingConnection(_ connection: AVCaptureConnection) -> Void {
        
    }
    
    func configureSession(with deviceInput: AVCaptureDeviceInput) {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        if session.canAddInput(deviceInput) { session.addInput(deviceInput) }
        if session.canAddOutput(videDataOutput) { session.addOutput(videDataOutput) }
    }
}

private extension SessionMediator {
    final class Delegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var bufferHandler: BufferHandler?
        let connectionHandler: (AVCaptureConnection) -> Void
        
        init(_ connectionBuffer: @escaping (AVCaptureConnection) -> Void) {
            self.connectionHandler = connectionBuffer
        }
        
        func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection
        ) {
            bufferHandler?(sampleBuffer)
            connectionHandler(connection)
        }
    }
    
    enum Error: LocalizedError {
        case capturingDeviceCreationFailure(Swift.Error)
        case permissionsCheckingFailure(Permissions.Error)
        case deviceProvidingFailure(DeviceProvider.Error)
    }
}
