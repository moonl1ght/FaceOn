//
//  DeviceProvider.swift
//  FaceOn
//
//  Created by Valery Kokanov on 01.06.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import Foundation
import AVFoundation

final class DeviceProvider {
    func createVideoDevice(
        with position: AVCaptureDevice.Position = .back
    ) -> Result<AVCaptureDevice, Error> {
        guard
            position != .unspecified,
            let device = discoverySession.devices.first(where: { $0.position == position })
        else {
            return .failure(.creatingDeviceFailure)
        }

        return .success(device)
    }
    
    func createAudioDevice() -> Result<AVCaptureDevice, Error> {
        guard
            let device = AVCaptureDevice.default(for: .audio)
        else {
            return .failure(.creatingDeviceFailure)
        }
        return .success(device)
    }
    
    private lazy var discoverySession = AVCaptureDevice.DiscoverySession.init(
        deviceTypes: [.builtInDualCamera, .builtInTrueDepthCamera],
        mediaType: .video,
        position: .unspecified
    )
    
    enum Error: Swift.Error {
        case creatingDeviceFailure
    }
}
