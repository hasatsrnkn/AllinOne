//
//  LoginErrorViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit
import AVFoundation
class LoginErrorViewController: UIViewController, AVAudioPlayerDelegate {
    
    let errorImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "login_error")
        image.isUserInteractionEnabled = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center // Align the text to center
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Futura", size: 23) ?? UIFont.systemFont(ofSize: 12) // Use Segoe UI font or fallback to system font
        ]
        errorLabel.attributedText = NSAttributedString(string: "Unauthorized Access Detected !", attributes: attributes)
        
        return errorLabel
    }()
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        playAudio()
    }
    
    private func setupSubViews() {
        [errorImage, errorLabel].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            
            errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImage.widthAnchor.constraint(equalToConstant: 300),
            errorImage.heightAnchor.constraint(equalToConstant: 300),
            
            errorLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 40),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            errorLabel.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    private func playAudio() {
        if let audioFileURL = Bundle.main.url(forResource: "login_error_audio", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                audioPlayer?.play()
                print("AVAudioPlayer created and audio playback started successfully.")
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found in the bundle.")
        }
    }
    
    
}
