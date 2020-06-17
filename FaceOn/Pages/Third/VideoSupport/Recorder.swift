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
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    private lazy var recordingDelegate = Delegate { result in
        switch result {
        case let .failure(error):
            self.delegate?.recorder(self, didFinishRecordingWithResult: .failed(error))
        case let .success(pair):
            self.delegate?.recorder(self, didFinishRecordingWithResult: .successed(pair.url))
        }
    }
}

extension Recorder {
    func start() {
        if fileOutput.isRecording { fileOutput.stopRecording() }
        let currentFileURL = createFileURL()
        self.currentFileURL = currentFileURL
        fileOutput.startRecording(to: currentFileURL, recordingDelegate: recordingDelegate)
    }
    
    func stop() {
        fileOutput.stopRecording()
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
        typealias Callback = (Result<(output: AVCaptureFileOutput, url: URL), Error>) -> Void
        
        let callback: Callback
        
        init(_ callback: @escaping Callback) {
            self.callback = callback
        }
        
        func fileOutput(
            _ output: AVCaptureFileOutput,
            didFinishRecordingTo outputFileURL: URL,
            from connections: [AVCaptureConnection],
            error: Error?
        ) {
            if let error = error {
                callback(.failure(error))
            } else {
                callback(.success((output, outputFileURL)))
            }
        }
    }
    
    enum RecordingResult {
        case successed(URL)
        case failed(Error)
    }
}
