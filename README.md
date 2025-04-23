# StreamingLabel

`StreamingLabel` is a custom `UILabel` subclass that animates text character-by-character, creating a streaming effect that mimics how responses are shown in AI chat interfaces.

## Demo
![Demo.gif](https://github.com/RaajeevChandran/StreamingLabel/blob/main/Demo.gif)

## Features
- Animate text with configurable speed
- Start, stop, and reset streaming
- Lightweight and easy to integrate

## Installation
Simply copy the `StreamingLabel` class into your project. No external dependencies required.

## Example
See [ViewController.swift](https://github.com/RaajeevChandran/StreamingLabel/blob/main/StreamingLabel/ViewController.swift) for a complete example that includes:
- Start/Stop/Reset buttons
- Slider to control streaming speed

## Usage

### Basic Setup
```swift
let label = StreamingLabel()
label.setStreamingSpeed(30) // 30 characters per second
label.stream("Lorem Ipsum is simply dummy text of the printing and typesetting industry")
```

### Stop
```swift
label.stopStreaming()
```

### Adjusting Speed
```swift
label.setStreamingSpeed(60) // 60 characters per second
```

### Getting Current Speed
```swift
let currentSpeed = label.charactersPerSecond
```

### Completion Delegate
```swift
class ViewController: UIViewController, StreamingLabelDelegate {
    
    let streamingLabel = StreamingLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streamingLabel.delegate = self
        
        streamingLabel.stream("Watch this text appear character by character.")
    }
    
    func didStreamingComplete() {
        print("Streaming completed!")
    }
}
```
