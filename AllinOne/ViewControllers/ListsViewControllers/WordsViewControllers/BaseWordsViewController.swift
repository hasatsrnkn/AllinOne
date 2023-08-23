//
//  BaseWordsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 22.08.2023.
//

import UIKit
import CoreData
import UserNotifications

class BaseWordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let backButton = BackButtonSingleton.shared.backButton
    let backgroundImageView = BackgroundImage(systemName: "words_background")
    var entityNameVar : String = "Words"
    var items: [NSManagedObject] = []
    
    
    private lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.backgroundColor = UIColor.clear
        tv.backgroundView = UIView()
        tv.alpha = 1.0
        return tv
    }()
    
    let horizontalLine : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .darkGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let turkishWordsImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "t.circle")
        image.tintColor = .gray
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let englishWordsImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "e.circle")
        image.tintColor = .gray
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let frenchWordsImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "f.circle")
        image.tintColor = .gray
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let wordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "The Word"
        textField.textColor = .white
        textField.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10 // Adjust the radius value as needed
        textField.layer.masksToBounds = true
        textField.layer.zPosition = 1.0
        
        return textField
    }()
    
    let meaningTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "The Meaning"
        textField.textColor = .white
        textField.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10 // Adjust the radius value as needed
        textField.layer.masksToBounds = true
        textField.layer.zPosition = 1.0
        
        return textField
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura", size: 25)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.clear
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        
        
        
    }
    
    func fetchItems() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityNameVar)
        
        // Sort the fetch request by the "word" attribute in ascending order
        let sortDescriptor = NSSortDescriptor(key: "word", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            items = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    
    private func setupSubViews() {
        [ backgroundImageView, backButton, addButton,wordTextField, meaningTextField,  horizontalLine, tableView, turkishWordsImage, englishWordsImage, frenchWordsImage,
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
            
            wordTextField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            wordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            wordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-40),
            wordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            meaningTextField.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 10),
            meaningTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            meaningTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-10),
            meaningTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.topAnchor.constraint(equalTo: meaningTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            
            horizontalLine.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 15),
            horizontalLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            horizontalLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            horizontalLine.heightAnchor.constraint(equalToConstant: 2),
            
            
            
            tableView.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: turkishWordsImage.topAnchor, constant: -10),
            
            turkishWordsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            turkishWordsImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            turkishWordsImage.widthAnchor.constraint(equalToConstant: 40),
            turkishWordsImage.heightAnchor.constraint(equalToConstant: 40),
            
            englishWordsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            englishWordsImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            englishWordsImage.widthAnchor.constraint(equalToConstant: 40),
            englishWordsImage.heightAnchor.constraint(equalToConstant: 40),
            
            frenchWordsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            frenchWordsImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            frenchWordsImage.widthAnchor.constraint(equalToConstant: 40),
            frenchWordsImage.heightAnchor.constraint(equalToConstant: 40),
            
            
        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let addButtonGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonClicked))
        addButton.addGestureRecognizer(addButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let englishGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(englishClicked))
        englishWordsImage.addGestureRecognizer(englishGestureRecognizer)
        
        let turkishGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(turkishClicked))
        turkishWordsImage.addGestureRecognizer(turkishGestureRecognizer)
        
        let frenchGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(frenchClicked))
        frenchWordsImage.addGestureRecognizer(frenchGestureRecognizer)
    }
    
    @objc func turkishClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "WordsViewController") as? WordsViewController {
            nextViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            transition.subtype = .fromRight
            view.window?.layer.add(transition, forKey: kCATransition)
            present(nextViewController, animated: false, completion: nil)
        }
    }

    @objc func englishClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "EnglishWordsViewController") as? EnglishWordsViewController {
            nextViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            transition.subtype = .fromRight
            view.window?.layer.add(transition, forKey: kCATransition)
            present(nextViewController, animated: false, completion: nil)
        }
    }

    @objc func frenchClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "FrenchWordsViewController") as? FrenchWordsViewController {
            nextViewController.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            transition.subtype = .fromRight
            view.window?.layer.add(transition, forKey: kCATransition)
            present(nextViewController, animated: false, completion: nil)
        }
    }

    
    
    @objc func handleTap() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MainMenuViewController")
        }
    }
    
    @objc func addButtonClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newWord = NSEntityDescription.insertNewObject(forEntityName: entityNameVar, into: context)
        newWord.setValue(wordTextField.text!, forKey: "word")
        newWord.setValue(meaningTextField.text!, forKey: "meaning")
        newWord.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Data saved successfully!")
            fetchItems() // Call fetchItems() to reload the table view with sorted items
            wordTextField.text = ""
            meaningTextField.text = ""
            scheduleRandomNotifications()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellIdentifier") // Set cell style
        
        let item = items[indexPath.row]
        let word = item.value(forKey: "word") as? String
        let meaning = item.value(forKey: "meaning") as? String
        
        cell.textLabel?.text = word
        cell.detailTextLabel?.text = meaning // Set the meaning as the subtitle
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont(name: "Futura", size: 14) ?? UIFont.systemFont(ofSize: 14)
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let itemToDelete = items[indexPath.row]
            
            context.delete(itemToDelete)
            
            do {
                try context.save()
                
                // Remove from the data source array
                items.remove(at: indexPath.row)
                
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
                fetchItems()
                scheduleRandomNotifications()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    
    func scheduleRandomNotifications() {
        
        let content = UNMutableNotificationContent()
        content.sound = .default

        if (entityNameVar == "Words") {
            content.title = "Günün Kelimesi" //Word of the Day
            
            let triggerInterval: TimeInterval = 3 * 60 * 60 // 60 seconds
            
            let requestIdentifier = "wordNotification"
            
            
            for i in 1...20{ // Schedule 10 notifications
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * Int(triggerInterval)), repeats: false)
                
                if let randomItem = items.randomElement(),
                   let word = randomItem.value(forKey: "word") as? String,
                   let meaning = randomItem.value(forKey: "meaning") as? String {
                    content.body = "\(word): \(meaning)"
                    
                    let request = UNNotificationRequest(identifier: "\(requestIdentifier)_\(i)", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        } else {
                            print("Notification scheduled successfully!")
                        }
                    }
                }
            }
        }
        else if(entityNameVar == "EnglishWords") {
            content.title = "Word of the Day" //Word of the Day
            
            let triggerInterval: TimeInterval = 3 * 60 * 60 // 60 seconds
            
            let requestIdentifier = "EnglishWordNotification"
            
            
            for i in 1...20{ // Schedule 10 notifications
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * Int(triggerInterval)), repeats: false)
                
                if let randomItem = items.randomElement(),
                   let word = randomItem.value(forKey: "word") as? String,
                   let meaning = randomItem.value(forKey: "meaning") as? String {
                    content.body = "\(word): \(meaning)"
                    
                    let request = UNNotificationRequest(identifier: "\(requestIdentifier)_\(i)", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        } else {
                            print("English Notification scheduled successfully!")
                        }
                    }
                }
            }
        }
        else if(entityNameVar == "FrenchWords") {
            content.title = "Mot Du Jou" //Word of the Day
            
            let triggerInterval: TimeInterval = 4 * 60 * 60 // 60 seconds
            
            let requestIdentifier = "FrenchWordNotification"
            
            
            for i in 1...20{ // Schedule 10 notifications
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * Int(triggerInterval)), repeats: false)
                
                if let randomItem = items.randomElement(),
                   let word = randomItem.value(forKey: "word") as? String,
                   let meaning = randomItem.value(forKey: "meaning") as? String {
                    content.body = "\(word): \(meaning)"
                    
                    let request = UNNotificationRequest(identifier: "\(requestIdentifier)_\(i)", content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error)")
                        } else {
                            print("French Notification scheduled successfully!")
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
}
