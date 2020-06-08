//
//  ImagesList.swift
//  FaceOn
//
//  Created by Valery Kokanov on 24.05.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import SwiftUI

struct ImagesList: View {
    init(
        images: [UIImage],
        imagesPerRow: Int = 6,
        allowMultipleSelections: Bool = false,
        _ handler: @escaping (Int) -> Void
    ) {
        self.handler = handler
        self.allowMultipleSelections = allowMultipleSelections
        self._rowsModels = .init(wrappedValue: images.transform(with: imagesPerRow))
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            images.padding([.leading, .trailing])

        }
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5)
        .shadow(color: Color.white, radius: 7, x: -5, y: -5)
    }
    
    private var images: some View {
        VStack(alignment: .center, spacing: 20) {
            ForEach(0 ..< rowsModels.count) { i in
                Row(items: self.rowsModels[i]) { index in
                    self.handler(index)
                    
                    guard self.allowMultipleSelections == false else { return }
                    
                    self.rowsModels = self.rowsModels.map { models -> [Model] in
                        models.map { item in
                            var item = item
                            item.isSelected = index == item.offset
                            return item
                        }
                    }
                }
            }
        }
    }
    
    private let handler: (Int) -> Void
    private let allowMultipleSelections: Bool
    
    @State private var rowsModels: [[Model]]
}

private extension ImagesList {
    struct Model {
        let offset: Int
        let image: UIImage
        var isSelected: Bool
    }
    
    struct Row: View {
        let items: [Model]
        let handler: (Int) -> Void
        
        var body: some View {
            HStack(alignment: .center, spacing: 20) {
                ForEach(0 ..< items.count) { i in
                    Image(uiImage: self.items[i].image)
                    .resizable()
                    .frame(width: 94, height: 94, alignment: .center)
                    .cornerRadius(15)
                    .shadow(radius: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            self.items[i].isSelected ? Color.yellow : Color.clear,
                            lineWidth: 7
                        )
                    )
                    .onTapGesture {
                        self.handler(self.items[i].offset)
                    }
                }
            }
        }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

private extension Array where Element == UIImage {
    func transform(with imagesPerRow: Int) -> [[ImagesList.Model]] {
        self.lazy
        .enumerated()
        .map { ImagesList.Model(offset: $0.offset, image: $0.element, isSelected: false) }
        .chunked(into: imagesPerRow)
    }
}

struct ImagesList_Previews: PreviewProvider {
    static var previews: some View {
        let array = [
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
        
        return ImagesList(images: array) { _ in }
    }
}
