//
//  MenuIcon.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//
import UIKit
import Foundation
class IconImageView: UIImageView {

    init(systemName: String) {
        super.init(frame: .zero)
        commonInit(systemName: systemName)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(systemName: "person") // Default system name "person" if initialized from a storyboard or XIB
    }

    private func commonInit(systemName: String) {
        self.image = UIImage(systemName: systemName)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleToFill
        self.tintColor = UIColor.white
        /*
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true
         */
    }
}

