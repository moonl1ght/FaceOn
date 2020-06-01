//
//  Permissions.swift
//  Talkit
//
//  Created by Valery Kokanov on 31.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

final class Permissions {
    init() {}
    
    func checkVideo() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { (promise: @escaping Future<Void, Error>.Promise) in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                promise(.success(()))
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { isGranted in
                    isGranted ? promise(.success(())) : promise(.failure(.wrongPermissionsStatus))
                }
            default:
                promise(.failure(.wrongPermissionsStatus))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func checkAudio() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { (promise: @escaping Future<Void, Error>.Promise) in
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            switch status {
            case .authorized:
                promise(.success(()))
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio) { isGranted in
                    isGranted ? promise(.success(())) : promise(.failure(.wrongPermissionsStatus))
                }
            default:
                promise(.failure(.wrongPermissionsStatus))
            }
        }
        .eraseToAnyPublisher()
    }
    
    enum Error: Swift.Error {
        case wrongPermissionsStatus
    }
}
