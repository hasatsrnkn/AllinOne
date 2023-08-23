//
//  AddButtonSingleton.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 7.08.2023.
//

import Foundation
import UIKit

class AddButtonSingleton {
    // Shared instance of the backButton
    static let shared = AddButtonSingleton()

    // Private initializer to prevent creating instances directly
    private init() {}

    // Lazy property to create the backButton
    lazy var addButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.white
        return image
    }()
}
