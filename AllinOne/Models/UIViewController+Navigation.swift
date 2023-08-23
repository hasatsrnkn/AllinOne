//
//  UIViewController+Navigation.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 17.08.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func navigateToNextViewController(viewController: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let animationDuration: TimeInterval = 0.3 // Animation duration in seconds

        let transition = CATransition()
                transition.duration = animationDuration
                transition.type = .fade
                view.window?.layer.add(transition, forKey: kCATransition)
        
        if(viewController == "MainMenuViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "PeopleViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "PeopleViewController") as? PeopleViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "CurrencyViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "CurrencyViewController") as? CurrencyViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "InstagramViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "InstagramViewController") as? InstagramViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "WordsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "WordsViewController") as? WordsViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "ShoppingViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "ShoppingViewController") as? ShoppingViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if(viewController == "ListsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "ListsViewController") as? ListsViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "ToDoListViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "ToDoListViewController") as? ToDoListViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "BilkentMenuViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "BilkentMenuViewController") as? BilkentMenuViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "LocationListViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "LocationListViewController") as? LocationListViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        
        else if(viewController == "MoviesDetailsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "MoviesDetailsViewController") as? MoviesDetailsViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else  if(viewController == "MoviesViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as? MoviesViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "LoginErrorViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "LoginErrorViewController") as? LoginErrorViewController {
                // Present the destination view controller
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "LocationDetailsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "LocationDetailsViewController") as? LocationDetailsViewController {
                // Present the destination view controller
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "AddLocationViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
                // Present the destination view controller
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "EnglishWordsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "EnglishWordsViewController") as? EnglishWordsViewController {
                // Present the destination view controller
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "FrenchWordsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "FrenchWordsViewController") as? FrenchWordsViewController {
                // Present the destination view controller
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        else if (viewController == "SettingsViewController") {
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                // Present the destination view controller
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        
        
        
        else {
        
            if let nextViewController = storyboard.instantiateViewController(withIdentifier: "LoginErrorViewController") as? LoginErrorViewController {
                nextViewController.modalPresentationStyle = .fullScreen
                self.present(nextViewController, animated: false, completion: nil)
            }
        }
        
    }
}
