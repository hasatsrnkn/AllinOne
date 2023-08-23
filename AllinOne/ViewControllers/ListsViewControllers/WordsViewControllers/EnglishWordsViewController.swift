//
//  WordsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UserNotifications

class EnglishWordsViewController: BaseWordsViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        englishWordsImage.tintColor = .white
        englishWordsImage.isUserInteractionEnabled = false
        entityNameVar = "EnglishWords"
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
