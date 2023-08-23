//
//  PeopleViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit
import CoreData

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let backButton = BackButtonSingleton.shared.backButton
    let backgroundImageView = BackgroundImage(systemName: "people_background")
    
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
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "The Name"
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
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistent date format
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
        
        fetchItems()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        // Request notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
        scheduleNotifications()
    }
    
    private func fetchItems() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friends")
        
        // Sort the fetch request by the "word" attribute in ascending order
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            items = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching items: \(error)")
        }
    }
    
    private func setupSubViews() {
        [backButton,backgroundImageView, nameTextField, datePicker, addButton, tableView, horizontalLine
        ].forEach { (item) in
            view.addSubview(item)
        }
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: Date()) - 100 // Max age: 100 years
        let minDate = calendar.date(from: dateComponents)
        dateComponents.year = calendar.component(.year, from: Date()) // Current year
        let maxDate = calendar.date(from: dateComponents)
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
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
            
            nameTextField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            datePicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            datePicker.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            
            horizontalLine.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 15),
            horizontalLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            horizontalLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            horizontalLine.heightAnchor.constraint(equalToConstant: 2),
            
            tableView.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let addButtonGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonClicked))
        addButton.addGestureRecognizer(addButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func addButtonClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friends", into: context)
        newFriend.setValue(nameTextField.text!, forKey: "name")
        newFriend.setValue(datePicker.date, forKey: "birthday")
        newFriend.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Data saved successfully!")
            fetchItems() // Call fetchItems() to reload the table view with sorted items
            nameTextField.text = ""
            scheduleNotifications()
        } catch {
            print("Error saving data: \(error)")
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellIdentifier") // Set cell style
        
        let item = items[indexPath.row]
        let name = item.value(forKey: "name") as? String
        let birthday = item.value(forKey: "birthday") as? Date
        
        cell.textLabel?.text = name
        
        // Format the birthday date to display only the date without the time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long // You can adjust the style based on your preference
        dateFormatter.timeStyle = .none
        if let formattedBirthday = birthday {
            cell.detailTextLabel?.text = dateFormatter.string(from: formattedBirthday)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
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
                scheduleNotifications()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    
    // Function to schedule a notification for a friend's birthday
    func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Friend's birthday"
        content.sound = .default
                
        for item in items {
            if let friendName = item.value(forKey: "name") as? String,
               let birthday = item.value(forKey: "birthday") as? Date {
                
                let calendar = Calendar.current
                let birthdayComponents = calendar.dateComponents([.month, .day], from: birthday)
                let currentYear = calendar.component(.year, from: Date())
                var birthdayDateComponents = DateComponents()
                birthdayDateComponents.year = currentYear
                birthdayDateComponents.month = birthdayComponents.month
                birthdayDateComponents.day = birthdayComponents.day
                
                if let birthdayThisYear = calendar.date(from: birthdayDateComponents),
                   let timeInterval = calendar.dateComponents([.second], from: Date(), to: birthdayThisYear).second,
                   timeInterval > 0 // Ensure the time interval is greater than 0
                {
                    content.body = "\(friendName)'s birthday is today!"
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeInterval), repeats: false)
                    let requestIdentifier = "birthdayNotification_\(friendName)"
                    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling birthday notification: \(error)")
                        } else {
                            print("Birthday notification scheduled successfully for \(friendName)!")
                        }
                    }
                }
            }
        }
    }

    
    
}
