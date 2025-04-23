//
//  StreamingLabel.swift
//  StreamingLabel
//
//  Created by Raajeev Chandran on 23/04/25.
//

import UIKit

@objc protocol StreamingLabelDelegate: NSObjectProtocol {
    @objc optional func didStreamingComplete()
}

class StreamingLabel: UILabel {
    weak var delegate: StreamingLabelDelegate?
    
    private var streamDelay: TimeInterval = 0.05
    
    private var targetText: String = ""
    private var currentIndex: String.Index?
    private var displayTimer: Timer?
    
    var charactersPerSecond: Float {
        Float(1.0 / streamDelay)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func stream(_ text: String) {
        // stop any existing animation
        displayTimer?.invalidate()
        displayTimer = nil
        
        // store the target text and completion handler
        targetText = text
        
        // start from empty if the new text is completely different
        if !text.hasPrefix(self.text ?? "") {
            self.text = ""
        }
        
        // set initial index based on current text length
        if let currentText = self.text, !currentText.isEmpty {
            currentIndex = text.index(text.startIndex, offsetBy: currentText.count)
        } else {
            currentIndex = text.startIndex
        }
        
        startStreaming()
    }
    
    private func startStreaming() {
        guard let currentIndex = currentIndex else { return }
        
        // if we've reached the end, call didStreamingComplete
        if currentIndex >= targetText.endIndex {
            delegate?.didStreamingComplete?()
            return
        }
        
        displayTimer = Timer.scheduledTimer(withTimeInterval: streamDelay, repeats: true) { [weak self] timer in
            guard let self = self,
                  let currentIndex = self.currentIndex,
                  currentIndex < self.targetText.endIndex else {
                timer.invalidate()
                self?.delegate?.didStreamingComplete?()
                return
            }
            
            // get the next character
            let nextIndex = self.targetText.index(after: currentIndex)
            let textToShow = String(self.targetText[...currentIndex])
            
            // update the text on the main thread
            DispatchQueue.main.async {
                self.text = textToShow
                self.currentIndex = nextIndex
            }
        }
        
        RunLoop.main.add(displayTimer!, forMode: .common)
    }
    
    func setStreamingSpeed(_ charactersPerSecond: Double) {
        guard charactersPerSecond > 0 else {
            // default fallback
            streamDelay = 0.05
            return
        }
        streamDelay = 1.0 / charactersPerSecond
    }

    
    func stopStreaming() {
        displayTimer?.invalidate()
        displayTimer = nil
    }

    deinit {
        displayTimer?.invalidate()
    }
}
