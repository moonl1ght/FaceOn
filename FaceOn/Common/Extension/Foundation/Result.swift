//
//  Result.swift
//  FaceOn
//
//  Created by Valery Kokanov on 01.06.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import Foundation
import Combine

extension Result {
    var publisher: AnyPublisher<Success, Failure> {
        Future<Success, Failure> { $0(self) }.eraseToAnyPublisher()
    }
}
