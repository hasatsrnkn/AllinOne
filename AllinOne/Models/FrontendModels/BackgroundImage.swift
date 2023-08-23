//
//  BackgroundImage.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 14.08.2023.
//

import Foundation
import UIKit
import Foundation
class BackgroundImage: UIImageView {

    init(systemName: String) {
        super.init(frame: .zero)
        commonInit(named : systemName)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(named : "person") // Default system name "person" if initialized from a storyboard or XIB
    }

    private func commonInit(named: String) {
        self.image = UIImage(named: named)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = false
        self.contentMode = .scaleToFill
        self.layer.zPosition = -2.0
        
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        // Adjust the alpha value to make the blur effect more subtle
        visualEffectView.alpha = 0.95
        self.addSubview(visualEffectView)
        
        NSLayoutConstraint.activate([
            visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        /*
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true
         */
    }
}
