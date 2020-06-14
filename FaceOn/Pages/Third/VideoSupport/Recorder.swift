//
//  Recorder.swift
//  FaceOn
//
//  Created by Valery Kokanov on 08.06.2020.
//  Copyright © 2020 Talkit team. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

protocol OutputProvider: AnyObject {
    var output: AVCaptureMovieFileOutput { get }
}

protocol RecorderDelegate: AnyObject {
    func recorder(_ recorder: Recorder, didFinishRecordingWithResult result: Recorder.RecordingResult)
}

final class Recorder {
    weak var delegate: RecorderDelegate?
    
    init(_ provider: OutputProvider) {
        fileOutput = provider.output
    }
    
    private let fileOutput: AVCaptureMovieFileOutput
    
    private var currentFileURL: URL?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private lazy var recordingDelegate = Delegate()
}

extension Recorder {
    func start() {
        recordingDelegate.callback = { result in
            switch result {
            case let .failure(error):
                print(error)
                self.delegate?.recorder(self, didFinishRecordingWithResult: .failed(error))
            case let .success(pair):
                let data = FileManager.default.contents(atPath: pair.url.path)
                print(data ?? "null")
                self.delegate?.recorder(self, didFinishRecordingWithResult: .successed(pair.url))
            }
        }
        
        if fileOutput.isRecording { fileOutput.stopRecording() }
        let currentFileURL = createFileURL()
        self.currentFileURL = currentFileURL
        fileOutput.startRecording(to: currentFileURL, recordingDelegate: recordingDelegate)
        
        let publisher = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .map { _ in }
    }
    
    func stop() {
        fileOutput.stopRecording()
        recordingDelegate.callback = nil
    }
}

private extension Recorder {
    func createFileURL() -> URL {
        let dateString = dateFormatter.string(from: Date())
        let fileName = (NSTemporaryDirectory() as NSString).appendingPathComponent(dateString.appending(".mov"))
        return URL(fileURLWithPath: fileName)
    }
}

extension Recorder {
    final class Delegate: NSObject, AVCaptureFileOutputRecordingDelegate {
        var callback: ((Result<(output: AVCaptureFileOutput, url: URL), AVError>) -> Void)?
        
        func fileOutput(
            _ output: AVCaptureFileOutput,
            didFinishRecordingTo outputFileURL: URL,
            from connections: [AVCaptureConnection],
            error: Error?
        ) {
            guard let callback = callback else { return }
            if
                let error = error,
                let avError = error as? AVError
            {
                callback(.failure(avError))
            }
            callback(.success((output, outputFileURL)))
        }
    }
    
    enum RecordingResult {
        case successed(URL)
        case failed(Error)
    }
}
