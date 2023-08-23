//
//  ShoppingViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 15.08.2023.
//

import UIKit
import CoreData

class ShoppingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backButton = BackButtonSingleton.shared.backButton
    let backgroundImageView = BackgroundImage(systemName: "shopping_background")
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
    
    let itemTextField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "The Item"
        textField.textColor = .white
        textField.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10 // Adjust the radius value as needed
        textField.layer.masksToBounds = true
        textField.layer.zPosition = 1.0
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 2, height: 2) // Adjust offset as needed
        textField.layer.shadowRadius = 4 // Adjust radius as needed
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
    
    let horizontalLine : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .darkGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupLayouts()
        setupActions()
        // Fetch items from CoreData and reload the table view
        fetchItems()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
    }
    
    private func setupSubViews() {
        [backButton, backgroundImageView, tableView, itemTextField, addButton, horizontalLine
        ].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func fetchItems() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shopping")
            
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        
            do {
                items = try context.fetch(fetchRequest)
                tableView.reloadData()
            } catch {
                print("Error fetching items: \(error)")
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
            
            itemTextField.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            itemTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            itemTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant:60),
            itemTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            addButton.leadingAnchor.constraint(equalTo: itemTextField.trailingAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            
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
    
    @objc func handleTap() {
            view.endEditing(true) // Dismiss the keyboard
        }

    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "ListsViewController")
        }
    }
    
    @objc func addButtonClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newShopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        newShopping.setValue(itemTextField.text!, forKey: "name")
        newShopping.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Data saved successfully!")
            fetchItems()
            itemTextField.text = ""
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count // Use the count of fetched items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
                
        let item = items[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "name") as? String
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
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
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    
}
