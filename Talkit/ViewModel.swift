//
//  ViewModel.swift
//  Talkit
//
//  Created by Valery Kokanov on 21.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    @Published var numbers: [Int] = []
    
    init() {
        let source = Array((0...100)).publisher.filter { $0.isMultiple(of: 2) }.collect()
        cancallables.insert(
            source.delay(
                for: .seconds(3),
                scheduler: DispatchQueue.main
            )
            .sink { self.numbers.append(contentsOf: $0) }
        )
    }
    
    private var cancallables = Set<AnyCancellable>()
}
