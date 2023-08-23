//
//  AddLocationViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 17.08.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddLocationViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {

    let backButton = BackButtonSingleton.shared.backButton
    let backgroundImageView = BackgroundImage(systemName: "location_background")
    var locationManager = CLLocationManager()

    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    var isFirstLocationUpdate = true // Add this property to keep track of the first location update

    
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
         
         textField.layer.shadowColor = UIColor.black.cgColor
         textField.layer.shadowOpacity = 0.5
         textField.layer.shadowOffset = CGSize(width: 2, height: 2) // Adjust offset as needed
         textField.layer.shadowRadius = 4 // Adjust radius as needed
         return textField
    }()
    
    let commentTextField : UITextField = {
        let textField = UITextField()
         textField.placeholder = "The Comment"
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
    
    private lazy var mapView : MKMapView = {
       let addingMapView = MKMapView()
        addingMapView.delegate = self
        addingMapView.translatesAutoresizingMaskIntoConstraints = false
        return addingMapView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubViews()
        setupLayouts()
        setupActions()
        
        mapView.showsUserLocation = true // Show the user's location on the map

    }
    

    private func setupSubViews() {
        [backButton, backgroundImageView, nameTextField, commentTextField, submitButton, mapView
        ].forEach { (item) in
            view.addSubview(item)
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            commentTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            
        
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            
            mapView.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 30),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -30)
            
            
        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
    
        let mapViewGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        mapViewGestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(mapViewGestureRecognizer)
        
        let submitButtonGesture = UITapGestureRecognizer(target: self, action: #selector(submitButtonClicked))
        submitButton.addGestureRecognizer(submitButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
            view.endEditing(true) // Dismiss the keyboard
        }
    
    @objc func submitButtonClicked() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        newPlace.setValue(nameTextField.text, forKey: "title")
        newPlace.setValue(commentTextField.text, forKey: "subtitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
        navigateToNextViewController(viewController: "LocationListViewController")
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "LocationListViewController")
        }
    }

    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameTextField.text
            annotation.subtitle = commentTextField.text
            self.mapView.addAnnotation(annotation)
            
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if isFirstLocationUpdate {
                let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView.setRegion(region, animated: true)
                isFirstLocationUpdate = false // Set it to false after the initial update
            }
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            /*
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            */
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
}
