//
//  ViewController.swift
//  StreamingLabel
//
//  Created by Raajeev Chandran on 23/04/25.
//

import UIKit

class ViewController: UIViewController {
    private let streamingLabel = StreamingLabel()
    private let startButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let speedSlider = UISlider()
    private let speedLabel = UILabel()

    private let controlsStackView = UIStackView()
    private let speedStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupViews()
        setupConstraints()
        configureActions()
    }

    private func setupViews() {
        streamingLabel.delegate = self
        
        startButton.setTitle("Start Typing", for: .normal)
        stopButton.setTitle("Stop Typing", for: .normal)
        resetButton.setTitle("Reset", for: .normal)

        speedLabel.font = .systemFont(ofSize: 14)
        setSpeedLabelText()

        speedSlider.minimumValue = 5
        speedSlider.maximumValue = 100
        speedSlider.value = streamingLabel.charactersPerSecond

        controlsStackView.axis = .vertical
        controlsStackView.spacing = 20
        controlsStackView.alignment = .center
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        controlsStackView.addArrangedSubview(startButton)
        controlsStackView.addArrangedSubview(stopButton)
        controlsStackView.addArrangedSubview(resetButton)

        speedStackView.axis = .vertical
        speedStackView.spacing = 8
        speedStackView.translatesAutoresizingMaskIntoConstraints = false
        speedStackView.addArrangedSubview(speedSlider)
        speedStackView.addArrangedSubview(speedLabel)

        [streamingLabel, controlsStackView, speedStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func configureActions() {
        startButton.addTarget(self, action: #selector(startTyping), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopTyping), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetLabel), for: .touchUpInside)
        speedSlider.addTarget(self, action: #selector(speedChanged), for: .valueChanged)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            streamingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            streamingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            streamingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            controlsStackView.topAnchor.constraint(equalTo: streamingLabel.bottomAnchor, constant: 30),
            controlsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            speedStackView.topAnchor.constraint(equalTo: controlsStackView.bottomAnchor, constant: 40),
            speedStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            speedStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func speedChanged(_ sender: UISlider) {
        streamingLabel.setStreamingSpeed(Double(sender.value))
        setSpeedLabelText()
    }

    private func setSpeedLabelText() {
        speedLabel.text = String(format: "Speed: %.2f", speedSlider.value / 100)
    }

    @objc private func startTyping() {
        resetLabel()
        streamingLabel.stream("""
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been \
        the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of \
        type and scrambled it to make a type specimen book.
        """)
    }

    @objc private func stopTyping() {
        streamingLabel.stopStreaming()
    }

    @objc private func resetLabel() {
        streamingLabel.stopStreaming()
        streamingLabel.text = ""
    }
}

extension ViewController: StreamingLabelDelegate {
    func didStreamingComplete() {
        print("Streaming completed!")
    }
}
