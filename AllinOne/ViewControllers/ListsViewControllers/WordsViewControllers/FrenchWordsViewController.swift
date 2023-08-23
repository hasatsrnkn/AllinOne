//
//  WordsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//


import UserNotifications

class FrenchWordsViewController: BaseWordsViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frenchWordsImage.tintColor = .white
        frenchWordsImage.isUserInteractionEnabled = false
        entityNameVar = "FrenchWords"
        fetchItems()
        
        // Request notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
        scheduleRandomNotifications()

    }
}
