//
//  LinearGradient.swift
//  FaceOn
//
//  Created by Valery Kokanov on 13.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(
            gradient: Gradient(
                colors: colors
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
