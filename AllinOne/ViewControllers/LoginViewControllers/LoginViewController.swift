//
//  ViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit
import LocalAuthentication
class LoginViewController: UIViewController {
    
    let backgroundImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "login_background")
        image.isUserInteractionEnabled = false
        image.contentMode = .scaleToFill
        image.layer.zPosition = -2.0
        return image
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in to the system", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura", size: 25)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.black
        
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let nameLabel : UILabel = {
       let label = UILabel()
        label.text = "Designed by Mehmet Hasat Serinkan"
        label.textColor = .white
        label.font = UIFont(name: "Futura-Italic", size: 12) ?? UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.zPosition = 1.0
        label.textAlignment = .center
    
     
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGlobalVariables()
    }
    
    private func setupSubViews() {
        [backgroundImageView, loginButton, nameLabel].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(loginAction))
        loginButton.addGestureRecognizer(loginGesture)
        
        
    }
    
    @objc func loginAction() {
        let authContext = LAContext()
        var error: NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available on this device
            let localizedReason = "Is it you?"
            
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (success, error) in
                if success {
                    // Biometric authentication succeeded
                    DispatchQueue.main.async {
                        print("Biometric authentication successful.")
                        self.navigateToNextViewController(viewController: "MainMenuViewController")
                    }
                } else {
                    // Biometric authentication failed or was canceled
                    if let error = error as? LAError {
                        DispatchQueue.main.async {
                            self.navigateToNextViewController(viewController: "LoginErrorViewController")
                        }
                    }
                }
            }
        } else {
            // Biometric authentication is not available on this device
            DispatchQueue.main.async {
                print("Biometric authentication not available on this device.")
                self.navigateToNextViewController(viewController: "LoginErrorViewController")
            }
        }
        
    }
    
}

