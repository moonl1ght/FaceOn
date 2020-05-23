//
//  FirstPageViewModel.swift
//  Talkit
//
//  Created by Valery Kokanov on 21.05.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import Combine
import class UIKit.UIImage

final class FirstPageViewModel: ObservableObject {
    @Published var images: [[(String, UIImage)]] = []
    
    init() {
        fetchImages()
    }
}

private extension FirstPageViewModel {
    func fetchImages() {
        let array = [
            Asset.ExamplePhotos.einstein,
            Asset.ExamplePhotos.eminem,
            Asset.ExamplePhotos.jobs,
            Asset.ExamplePhotos.mona,
            Asset.ExamplePhotos.obama,
            Asset.ExamplePhotos.potter,
            Asset.ExamplePhotos.ronaldo,
            Asset.ExamplePhotos.schwarzenegger,
            Asset.ExamplePhotos.trump,
        ]
        .map { ($0.name, $0.image) }
        .chunked(into: 3)
        
        images.append(contentsOf: array)
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
