//
//  MoviesDetailsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 7.08.2023.
//

import UIKit
import CoreData

class MoviesDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let backButton = BackButtonSingleton.shared.backButton
    let seasonData = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
    let episodeData = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    
    var chosenSeries = ""
    var chosenSeriesID : UUID?
    
    let backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "movies_background")
        image.isUserInteractionEnabled = false
        image.contentMode = .scaleAspectFill
        image.layer.zPosition = -2.0
        
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        image.addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            visualEffectView.topAnchor.constraint(equalTo: image.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: image.bottomAnchor)
        ])
        
        return image
    }()
    
    let movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "photo")
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleToFill
        image.layer.zPosition = 1.0
        image.tintColor = .white
        image.layer.cornerRadius = 20.0
        
        image.layer.masksToBounds = true
        return image
    }()
    
    let movieNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please Enter the Series Name"
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
    
    let seasonLabel : UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Season"
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    let episodeLabel : UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Episode"
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    let submitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Futura", size: 25)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.gray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var seasonPickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var episodePickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
        changeViews()
        
        
    }
    
    private func changeViews() {
        if( chosenSeries != "" ) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
            let idString = chosenSeriesID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String {
                            movieNameTextField.text = name
                        }
                        
                        if let season = result.value(forKey: "season") as? Int {
                            let seasonIndex = season - 1 // Adjust for 0-based indexing
                            seasonPickerView.selectRow(seasonIndex, inComponent: 0, animated: true)
                        }
                        
                        if let episode = result.value(forKey: "episode") as? Int {
                            let episodeIndex = episode - 1 // Adjust for 0-based indexing
                            episodePickerView.selectRow(episodeIndex, inComponent: 0, animated: true)
                        }
                        
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            movieImage.image = image
                        }
                        
                    }
                }
                
            } catch{
                print("error")
            }
        }
    }
    
    private func setupSubViews() {

        
        [movieImage, backButton,backgroundImageView, movieNameTextField,seasonLabel,episodeLabel, submitButton, episodePickerView, seasonPickerView
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
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            movieImage.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            movieImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 180),
            movieImage.widthAnchor.constraint(equalToConstant: 300),
            
            movieNameTextField.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 60),
            movieNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieNameTextField.heightAnchor.constraint(equalToConstant: 40),
            movieNameTextField.widthAnchor.constraint(equalToConstant: 300),
            
            seasonLabel.topAnchor.constraint(equalTo: movieNameTextField.bottomAnchor, constant: 50),
            seasonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            seasonLabel.heightAnchor.constraint(equalToConstant: 20),
            seasonLabel.widthAnchor.constraint(equalToConstant: 100),
            
            episodeLabel.topAnchor.constraint(equalTo: movieNameTextField.bottomAnchor, constant: 50),
            episodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            episodeLabel.heightAnchor.constraint(equalToConstant: 20),
            episodeLabel.widthAnchor.constraint(equalToConstant: 100),
            
            seasonPickerView.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: 10),
            seasonPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            seasonPickerView.heightAnchor.constraint(equalToConstant: 100),
            seasonPickerView.widthAnchor.constraint(equalToConstant: 100),
            
            episodePickerView.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 10),
            episodePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            episodePickerView.heightAnchor.constraint(equalToConstant: 100),
            episodePickerView.widthAnchor.constraint(equalToConstant: 100),
            
            submitButton.topAnchor.constraint(equalTo: episodePickerView.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 180)
            
        ])
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == seasonPickerView {
            return seasonData.count
        } else if pickerView == episodePickerView {
            return episodeData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == seasonPickerView {
            return seasonData[row].description
        } else if pickerView == episodePickerView {
            return episodeData[row].description
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == seasonPickerView {
            let selectedOption = seasonData[row]
            print("Selected option for picker 1: \(selectedOption)")
        } else if pickerView == episodePickerView {
            let selectedChoice = episodeData[row]
            print("Selected choice for picker 2: \(selectedChoice)")
        }
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let movieImageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        movieImage.addGestureRecognizer(movieImageGesture)
        
        let submitButtonGesture = UITapGestureRecognizer(target: self, action: #selector(submitButtonClicked))
        submitButton.addGestureRecognizer(submitButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
            view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MoviesViewController")
        }
    }
    
    @objc func submitButtonClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var seriesToUpdate: NSManagedObject?
        if let existingUUID = chosenSeriesID {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Series")
            fetchRequest.predicate = NSPredicate(format: "id = %@", existingUUID as CVarArg)
            fetchRequest.fetchLimit = 1
            
            do {
                let results = try context.fetch(fetchRequest)
                if let existingSeries = results.first as? NSManagedObject {
                    seriesToUpdate = existingSeries
                }
            } catch {
                print("Error fetching existing data: \(error)")
            }
        }
        
        let seasonPick = seasonPickerView.selectedRow(inComponent: 0) + 1
        let episodePick = episodePickerView.selectedRow(inComponent: 0) + 1
        
        if let series = seriesToUpdate {
            // Update existing object
            series.setValue(movieNameTextField.text!, forKey: "name")
            series.setValue(seasonPick, forKey: "season")
            series.setValue(episodePick, forKey: "episode")
            let data = movieImage.image!.jpegData(compressionQuality: 0.5)
            series.setValue(data, forKey: "image")
        } else {
            // Insert new object
            let newSeries = NSEntityDescription.insertNewObject(forEntityName: "Series", into: context)
            newSeries.setValue(movieNameTextField.text!, forKey: "name")
            newSeries.setValue(seasonPick, forKey: "season")
            newSeries.setValue(episodePick, forKey: "episode")
            newSeries.setValue(UUID(), forKey: "id")
            let data = movieImage.image!.jpegData(compressionQuality: 0.5)
            newSeries.setValue(data, forKey: "image")
        }
        
        do {
            try context.save()
            print("Data saved successfully!")
        } catch {
            print("Error saving data: \(error)")
        }
        
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MoviesViewController")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        movieImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
