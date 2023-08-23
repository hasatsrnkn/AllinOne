//
//  MainMenuViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    let backgroundImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "login_background")
        image.isUserInteractionEnabled = false
        image.contentMode = .scaleToFill
        image.layer.zPosition = -2.0
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 22) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear        
        label.layer.zPosition = 1.0
        
        let iconImage = UIImage(named: "AppIcon")
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = 12
        iconImageView.layer.masksToBounds = true
        label.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5),
            iconImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        label.text = "AllinOne"
        return label
    }()
    
    
   
    
    let imageButton1 = IconImageView(systemName: "person")
    let imageButton2 = IconImageView(systemName: "list.bullet.clipboard")
    let imageButton3 = IconImageView(systemName: "turkishlirasign")
    let imageButton4 = IconImageView(systemName: "photo.circle")
    let imageButton5 = IconImageView(systemName: "book")
    let imageButton6 = IconImageView(systemName: "popcorn")
    let settingsButton = IconImageView(systemName: "gear")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
    }
    
    private func setupSubViews() {
        [backgroundImageView,imageButton1, imageButton2, imageButton3, imageButton4, imageButton5,
         imageButton6, settingsButton, nameLabel
        ].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func setupActions() {
        
        let imageButton1Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton1Action))
        imageButton1.addGestureRecognizer(imageButton1Gesture)
        
        let imageButton2Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton2Action))
        imageButton2.addGestureRecognizer(imageButton2Gesture)
        
        let imageButton3Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton3Action))
        imageButton3.addGestureRecognizer(imageButton3Gesture)
        
        let imageButton4Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton4Action))
        imageButton4.addGestureRecognizer(imageButton4Gesture)
        
        let imageButton5Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton5Action))
        imageButton5.addGestureRecognizer(imageButton5Gesture)
        
        let imageButton6Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton6Action))
        imageButton6.addGestureRecognizer(imageButton6Gesture)
        
        let settingsButtonGesture = UITapGestureRecognizer(target: self, action: #selector(settingsClicked))
        settingsButton.addGestureRecognizer(settingsButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func settingsClicked() {
        print("settings clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "SettingsViewController")
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc func imageButton1Action() {
        print("button 1 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "PeopleViewController")
        }
    }
    
    @objc func imageButton2Action() {
        print("button 2 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "ListsViewController")
        }
    }
    
    @objc func imageButton3Action() {
        print("button 3 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "CurrencyViewController")
        }
    }
    
    @objc func imageButton4Action() {
        print("button 4 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "InstagramViewController")
        }
    }
    
    @objc func imageButton5Action() {
        print("button 5 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "WordsViewController")
        }
    }
    
    @objc func imageButton6Action() {
        print("button 6 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MoviesViewController")
        }
    }
    
    private func setupLayouts(){
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            settingsButton.heightAnchor.constraint(equalToConstant: 35),
            settingsButton.widthAnchor.constraint(equalToConstant: 35),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            nameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            
            imageButton1.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            imageButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageButton1.heightAnchor.constraint(equalToConstant: 160),
            imageButton1.widthAnchor.constraint(equalToConstant: 160),
            
            imageButton2.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            imageButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageButton2.heightAnchor.constraint(equalToConstant: 160),
            imageButton2.widthAnchor.constraint(equalToConstant: 160),
            
            imageButton3.topAnchor.constraint(equalTo: imageButton1.bottomAnchor, constant: 100),
            imageButton3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageButton3.heightAnchor.constraint(equalToConstant: 160),
            imageButton3.widthAnchor.constraint(equalToConstant: 160),
            
            imageButton4.topAnchor.constraint(equalTo: imageButton2.bottomAnchor, constant: 100),
            imageButton4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageButton4.heightAnchor.constraint(equalToConstant: 160),
            imageButton4.widthAnchor.constraint(equalToConstant: 160),
            
            imageButton5.topAnchor.constraint(equalTo: imageButton3.bottomAnchor, constant: 100),
            imageButton5.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageButton5.heightAnchor.constraint(equalToConstant: 160),
            imageButton5.widthAnchor.constraint(equalToConstant: 160),
            
            imageButton6.topAnchor.constraint(equalTo: imageButton4.bottomAnchor, constant: 100),
            imageButton6.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageButton6.heightAnchor.constraint(equalToConstant: 160),
            imageButton6.widthAnchor.constraint(equalToConstant: 160),
        ])
        
    }
    
    
    
    
}
