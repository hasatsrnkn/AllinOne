//
//  InstagramViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit

class InstagramViewController: UIViewController {

    let backButton = BackButtonSingleton.shared.backButton

    let backgroundImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "login_background")
        image.isUserInteractionEnabled = false
        image.contentMode = .scaleToFill
        image.layer.zPosition = -2.0
        return image
    }()
    
    let preAlphaLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 30) ?? UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "PRE-ALPHA STAGE"
        return label
    }()
    
    let workingOnItLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "We are working on it"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
    }
    
    private func setupSubViews() {
        [backButton, backgroundImageView, preAlphaLabel,workingOnItLabel
        ].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            preAlphaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            preAlphaLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            
            workingOnItLabel.topAnchor.constraint(equalTo: preAlphaLabel.bottomAnchor, constant: 10),
            workingOnItLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workingOnItLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
            view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MainMenuViewController")
        }
    }

}
