//
//  ListsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit

class ListsViewController: UIViewController {

    let backButton = BackButtonSingleton.shared.backButton

    let backgroundImageView = BackgroundImage(systemName: "lists_background")
    
    let imageButton1 = IconImageView(systemName: "list.clipboard") //todo
    let imageButton2 = IconImageView(systemName: "fork.knife") //alışveriş
    let imageButton3 = IconImageView(systemName: "menucard") //bilkent yemek
    let imageButton4 = IconImageView(systemName: "mappin.circle") //konumlar
    
    let imageButton1Label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        
        label.layer.zPosition = 1.0
        
        label.text = "To-Do List"
        return label
    }()
    
    let imageButton2Label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        
        label.layer.zPosition = 1.0
        
        label.text = "Shopping List"
        return label
    }()
    
    let imageButton3Label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        
        label.layer.zPosition = 1.0
        
        label.text = "Bilkent Menu"
        return label
    }()
    
    let imageButton4Label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 17) ?? UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        
        label.layer.zPosition = 1.0
        
        label.text = "Location List"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupLayouts()
        setupActions()
    }
    
    private func setupSubViews() {
        [backButton,backgroundImageView, imageButton1, imageButton2, imageButton3, imageButton4,
         imageButton1Label, imageButton2Label, imageButton3Label, imageButton4Label,
        ].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func setupLayouts() {
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            imageButton1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            imageButton1.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -150),
            imageButton1.heightAnchor.constraint(equalToConstant: 125),
            imageButton1.widthAnchor.constraint(equalToConstant: 125),
            
            imageButton1Label.centerXAnchor.constraint(equalTo: imageButton1.centerXAnchor, constant: 0),
            imageButton1Label.leadingAnchor.constraint(equalTo: imageButton1.leadingAnchor, constant: 0),
            imageButton1Label.trailingAnchor.constraint(equalTo: imageButton1.trailingAnchor, constant: 0),
            imageButton1Label.topAnchor.constraint(equalTo: imageButton1.bottomAnchor, constant: 10),
            imageButton1Label.heightAnchor.constraint(equalToConstant: 40),
            
            imageButton2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            imageButton2.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -150),
            imageButton2.heightAnchor.constraint(equalToConstant: 125),
            imageButton2.widthAnchor.constraint(equalToConstant: 125),
      
            imageButton2Label.centerXAnchor.constraint(equalTo: imageButton2.centerXAnchor, constant: 0),
            imageButton2Label.leadingAnchor.constraint(equalTo: imageButton2.leadingAnchor, constant: 0),
            imageButton2Label.trailingAnchor.constraint(equalTo: imageButton2.trailingAnchor, constant: 0),
            imageButton2Label.topAnchor.constraint(equalTo: imageButton2.bottomAnchor, constant: 10),
            imageButton2Label.heightAnchor.constraint(equalToConstant: 40),
            
            imageButton3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            imageButton3.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 150),
            imageButton3.heightAnchor.constraint(equalToConstant: 125),
            imageButton3.widthAnchor.constraint(equalToConstant: 125),
            
            imageButton3Label.centerXAnchor.constraint(equalTo: imageButton3.centerXAnchor, constant: 0),
            imageButton3Label.leadingAnchor.constraint(equalTo: imageButton3.leadingAnchor, constant: 0),
            imageButton3Label.trailingAnchor.constraint(equalTo: imageButton3.trailingAnchor, constant: 0),
            imageButton3Label.topAnchor.constraint(equalTo: imageButton3.bottomAnchor, constant: 10),
            imageButton3Label.heightAnchor.constraint(equalToConstant: 40),

            imageButton4.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            imageButton4.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 150),
            imageButton4.heightAnchor.constraint(equalToConstant: 125),
            imageButton4.widthAnchor.constraint(equalToConstant: 125),
            
            imageButton4Label.centerXAnchor.constraint(equalTo: imageButton4.centerXAnchor, constant: 0),
            imageButton4Label.leadingAnchor.constraint(equalTo: imageButton4.leadingAnchor, constant: 0),
            imageButton4Label.trailingAnchor.constraint(equalTo: imageButton4.trailingAnchor, constant: 0),
            imageButton4Label.topAnchor.constraint(equalTo: imageButton4.bottomAnchor, constant: 10),
            imageButton4Label.heightAnchor.constraint(equalToConstant: 40),

        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let imageButton1Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton1Action))
        imageButton1.addGestureRecognizer(imageButton1Gesture)
        
        let imageButton2Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton2Action))
        imageButton2.addGestureRecognizer(imageButton2Gesture)
        
        let imageButton3Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton3Action))
        imageButton3.addGestureRecognizer(imageButton3Gesture)
        
        let imageButton4Gesture = UITapGestureRecognizer(target: self, action: #selector(imageButton4Action))
        imageButton4.addGestureRecognizer(imageButton4Gesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
            view.endEditing(true) // Dismiss the keyboard
        }
    
    @objc func imageButton1Action() {
        print("button 1 clicked")
        DispatchQueue.main.async { [weak self] in
            self?.navigateToNextViewController(viewController: "ToDoListViewController")
        }
    }
    
    @objc func imageButton2Action() {
        print("button 2 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "ShoppingViewController")
        }
    }
    
    @objc func imageButton3Action() {
        print("button 3 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "BilkentMenuViewController")
        }
    }
    
    @objc func imageButton4Action() {
        print("button 4 clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "LocationListViewController")
        }
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MainMenuViewController")
        }
    }
    
    
    

}
