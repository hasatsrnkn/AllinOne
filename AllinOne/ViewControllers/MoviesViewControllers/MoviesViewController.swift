//
//  MoviesViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit
import CoreData

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let backButton = BackButtonSingleton.shared.backButton
    let addButton = AddButtonSingleton.shared.addButton
    let backgroundImageView = BackgroundImage(systemName: "movies_background")

    var nameArray = [String]()
    var imageArray = [Data]()
    var idArray = [UUID]()
    
    var selectedSeries = ""
    var selectedSeriesID : UUID?
    
    
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
        
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
        
        getData()
        
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: "MoviesTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func getData() {
        nameArray.removeAll()
        idArray.removeAll()
        imageArray.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String,
                   let id = result.value(forKey: "id") as? UUID,
                   let image = result.value(forKey: "image") as? Data {
                    nameArray.append(name)
                    idArray.append(id)
                    imageArray.append(image)
                }
            }
            
            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func setupSubViews() {
        [backButton, addButton, tableView, backgroundImageView
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
            
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
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
            self.navigateToNextViewController(viewController: "MainMenuViewController")
        }
    }
    
    @objc func addButtonClicked() {
        print("add clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MoviesDetailsViewController")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let name = nameArray[indexPath.row]
        cell.movieName.text = name
        cell.backgroundColor = .clear // Set the cell's background color to clear
        
        if let image = UIImage(data: imageArray[indexPath.row]) {
            cell.movieImage.image = image
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
            
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
                                nameArray.remove(at: indexPath.row)
                                imageArray.remove(at: indexPath.row)
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
        selectedSeries = nameArray[indexPath.row]
        selectedSeriesID = idArray[indexPath.row]
        
        // Create a fade transition animation
        let animationDuration: TimeInterval = 0.3 // Animation duration in seconds
        let transition = CATransition()
        transition.duration = animationDuration
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        
        // Present the next view controller with the fade animation
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "MoviesDetailsViewController") as? MoviesDetailsViewController {
            nextViewController.chosenSeries = selectedSeries
            nextViewController.chosenSeriesID = selectedSeriesID
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: false, completion: nil) // Use animated false to let the transition handle the animation
        }
    }

    
}
