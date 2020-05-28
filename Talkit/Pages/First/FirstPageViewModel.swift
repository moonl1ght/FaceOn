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
    @Published var images: [UIImage] = []
    
    init() {
        fetchImages()
    }
}

private extension FirstPageViewModel {
    func fetchImages() {
        images.append(
            contentsOf: [
                Asset.ExamplePhotos.bezos,
                Asset.ExamplePhotos.billy,
                Asset.ExamplePhotos.edsheeran,
                Asset.ExamplePhotos.einstein,
                Asset.ExamplePhotos.eminem,
                Asset.ExamplePhotos.jobs,
                Asset.ExamplePhotos.kanye,
                Asset.ExamplePhotos.kim1,
                Asset.ExamplePhotos.kim2,
                Asset.ExamplePhotos.mona,
                Asset.ExamplePhotos.musk,
                Asset.ExamplePhotos.obama,
                Asset.ExamplePhotos.potter,
                Asset.ExamplePhotos.ronaldo,
                Asset.ExamplePhotos.schwarz,
                Asset.ExamplePhotos.takeshi,
                Asset.ExamplePhotos.trump,
                Asset.ExamplePhotos.zuck,
            ]
            .map { $0.image }
        )
    }
}
