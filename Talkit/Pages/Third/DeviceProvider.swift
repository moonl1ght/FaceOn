//
//  DeviceProvider.swift
//  Talkit
//
//  Created by Valery Kokanov on 01.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import AVFoundation

final class DeviceProvider {
    func createVideoDevice() -> Result<AVCaptureDevice, Error> {
        let devices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera],
            mediaType: .video,
            position: .unspecified
        )
        .devices
        
        guard
            let device = devices.first
        else {
             return .failure(.creatingDeviceFailure)
        }
        return .success(device)
    }
    
    enum Error: Swift.Error {
        case creatingDeviceFailure
    }
}
