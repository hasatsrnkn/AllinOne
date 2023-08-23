//
//  BilkentMenuViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 16.08.2023.
//

import UIKit
import WebKit

class BilkentMenuViewController: UIViewController {
    
    let backButton = BackButtonSingleton.shared.backButton
    let backgroundImageView = BackgroundImage(systemName: "lists_background")

    var webView: WKWebView!
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupLayouts()
        setupActions()
        loadWebContent()
        
    }
    
    
    private func setupSubViews() {
        [backButton, backgroundImageView
        ].forEach { (item) in
            view.addSubview(item)
        }
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        // Create a WKWebView
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
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
            
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }
    
    private func loadWebContent() {
        loadingIndicator.startAnimating()
        if let url = URL(string: "http://kafemud.bilkent.edu.tr/monu_eng.html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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
            self.navigateToNextViewController(viewController: "ListsViewController")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    
}
