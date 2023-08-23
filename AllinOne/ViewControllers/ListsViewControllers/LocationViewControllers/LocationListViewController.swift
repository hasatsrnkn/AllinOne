//
//  LocationListViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 16.08.2023.
//

import UIKit
import CoreData

class LocationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backButton = BackButtonSingleton.shared.backButton
    let addButton = AddButtonSingleton.shared.addButton
    let backgroundImageView = BackgroundImage(systemName: "location_background")
    
    var titleArray = [String]()
    var idArray = [UUID]()
    
    var selectedTitle = ""
    var selectedTitleID : UUID?
    
    private lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
        tv.backgroundColor = UIColor.clear // Set the background color of the tableView to clear (transparent)
        tv.backgroundView = UIView() // Set an empty transparent view as the backgroundView
        tv.alpha = 1.0 // Set the alpha value of the tableView to 1.0 (fully opaque)
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        setupLayouts()
        setupActions()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
    @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                titleArray.removeAll()
                idArray.removeAll()
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        titleArray.append(title)
                        if let id = result.value(forKey: "id") as? UUID {
                            idArray.append(id)
                        }
                    }
                }
                
                // Sort titleArray and idArray alphabetically based on titles
                let sortedIndices = titleArray.indices.sorted { titleArray[$0] < titleArray[$1] }
                titleArray = sortedIndices.map { titleArray[$0] }
                idArray = sortedIndices.map { idArray[$0] }
                
                tableView.reloadData()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    
    private func setupSubViews() {
        [backButton, backgroundImageView, addButton, tableView
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
            
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 60),
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
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "ListsViewController")
        }
    }
    
    @objc func addButtonClicked() {
        print("add clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "AddLocationViewController")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                titleArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.deleteRows(at: [indexPath], with: .fade)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                    
                                } catch {
                                    print("error")
                                }
                                
                                break
                                
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titleArray[indexPath.row]
        selectedTitleID = idArray[indexPath.row]
        
        // Create a fade transition animation
        let animationDuration: TimeInterval = 0.3 // Animation duration in seconds
        let transition = CATransition()
        transition.duration = animationDuration
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        
        // Present the next view controller with the fade animation
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "LocationDetailsViewController") as? LocationDetailsViewController {
            nextViewController.selectedTitle = selectedTitle
            nextViewController.selectedTitleID = selectedTitleID
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: false, completion: nil) // Use animated false to let the transition handle the animation
        }
    }

}
