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
    func createVideoDevice() -> Result<AVCaptureDevice, Error> {
        guard
            let device = AVCaptureDevice.default(
                .builtInDualCamera,
                for: .video,
                position: .unspecified
            )
        else {
            return .failure(.creatingDeviceFailure)
        }
        return .success(device)
    }
    
    func createAudioDevice() -> Result<AVCaptureDevice, Error> {
        guard
            let device = AVCaptureDevice.default(
                .builtInMicrophone,
                for: .audio,
                position: .unspecified
            )
        else {
            return .failure(.creatingDeviceFailure)
        }
        return .success(device)
    }
    
    enum Error: Swift.Error {
        case creatingDeviceFailure
    }
}
