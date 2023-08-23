//
//  BackToMainMenuButtonSingleton.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import Foundation
import UIKit

class BackButtonSingleton {
    // Shared instance of the backButton
    static let shared = BackButtonSingleton()

    // Private initializer to prevent creating instances directly
    private init() {}

    // Lazy property to create the backButton
    lazy var backButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.left")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.white
        return image
    }()
}
