//
//  PreviewViewController.swift
//  FaceOn
//
//  Created by Valery Kokanov on 08.06.2020.
//  Copyright © 2020 FaceOn team. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import AVFoundation

// MARK: - Wrapper

final class PreviewViewControllerWrapper: UIViewControllerRepresentable {
    init(_ sessionProvider: SessionProvider) {
        self.sessionProvider = sessionProvider
    }
    
    func makeUIViewController(context: Context) -> PreviewViewController {
        .init(sessionProvider: sessionProvider)
    }
    
    func updateUIViewController(_ uiViewController: PreviewViewController, context: Context) {}
    
    private let sessionProvider: SessionProvider
}

// MARK: - Controller

final class PreviewViewController: UIViewController {
    init(
        sessionProvider: SessionProvider,
        notificationCenter: NotificationCenter = .default
    ) {
        self.sessionProvider = sessionProvider
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let customView = VideRenderingView(session: sessionProvider.session)
        setup(customView)
        view = customView
    }
    
    private let sessionProvider: SessionProvider
    private let notificationCenter: NotificationCenter
    
    private var cancellables = Set<AnyCancellable>()
}

private extension PreviewViewController {
    func setup(_ customView: VideRenderingView) {
        customView.mode = .inactive
        
        let didStartSource = notificationCenter.publisher(for: .AVCaptureSessionDidStartRunning)
        .map { _ in VideRenderingView.Mode.capturing }
        
        let didStopSource = notificationCenter.publisher(for: .AVCaptureSessionDidStopRunning)
        .map { _ in VideRenderingView.Mode.inactive }
        
        Publishers.Merge(
            didStartSource, didStopSource
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveValue: { customView.mode = $0 }
        )
        .store(in: &cancellables)
    }
}

// MARK: - View

final class VideRenderingView: UIView {
    var mode: Mode = .inactive {
        didSet {
            switch mode {
            case .inactive:
                backgroundColor = .black
            case .capturing:
                backgroundColor = .clear
            }
        }
    }
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        captureLayer.session = session
        captureLayer.videoGravity = .resizeAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    
    private var captureLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

extension VideRenderingView {
    enum Mode {
        case inactive
        case capturing
    }
}
