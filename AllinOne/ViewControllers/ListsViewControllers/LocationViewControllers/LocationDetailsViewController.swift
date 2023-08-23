//
//  LocationDetailsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 17.08.2023.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class LocationDetailsViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    let backButton = BackButtonSingleton.shared.backButton
    let backgroundImageView = BackgroundImage(systemName: "location_background")
    var locationManager = CLLocationManager()
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()
    
    let gasPriceViewModel = GasPriceViewModel()
    var gasPrice = Double()
    
    var userLocation: CLLocation?
    
    var selectedTitle = ""
    var selectedTitleID : UUID?
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .gray
        label.layer.cornerRadius = 10 // Adjust the radius value as needed
        label.layer.masksToBounds = true
        label.layer.zPosition = 1.0
        return label
    }()
    
    let commentLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .gray
        label.layer.cornerRadius = 10 // Adjust the radius value as needed
        label.layer.masksToBounds = true
        label.layer.zPosition = 1.0
        return label
    }()
    
    private lazy var mapView : MKMapView = {
        let addingMapView = MKMapView()
        addingMapView.delegate = self
        addingMapView.translatesAutoresizingMaskIntoConstraints = false
        return addingMapView
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Distance: Loading..."
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.cornerRadius = 10 // Adjust the radius value as needed
        label.layer.masksToBounds = true
        label.layer.zPosition = 1.0
        return label
    }()
    
    let estimatedGasPriceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Estimated Gas Price: Loading..."
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.cornerRadius = 10 // Adjust the radius value as needed
        label.layer.masksToBounds = true
        label.layer.zPosition = 1.0
        return label
    }()
    
    let noCarErrorLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "There Is No Car"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupLayouts()
        setupActions()
        fetchGasPrices()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGlobalVariables()
        updateUIViews()
    }
    
    func updateUIViews() {
        if (globalCarName == "") {
            estimatedGasPriceLabel.isHidden = true
            
            view.addSubview(noCarErrorLabel)
            
            NSLayoutConstraint.activate([
                noCarErrorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
                noCarErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                noCarErrorLabel.heightAnchor.constraint(equalToConstant: 40),
                noCarErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                noCarErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                
            ])
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the userLocation property when the location updates
        if let userLocation = locations.last {
            self.userLocation = userLocation
            
            // If you need to perform any other actions based on the user's location update, you can do it here.
            
            updateDistanceAndEstimatedPrice()
        }
    }
    
    func calculateDrivingDistance(from source: CLLocation, to destination: CLLocation, completion: @escaping (Double) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: source.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error)")
                }
                completion(0.0)  // Return 0.0 as the distance in case of an error
                return
            }
            
            let route = response.routes[0]  // Assuming there's only one route
            let distance = route.distance  // Distance in meters
            
            // Convert distance to kilometers
            let distanceInKilometers = distance / 1000
            
            completion(distanceInKilometers)
        }
    }
    
    func updateDistanceAndEstimatedPrice() {
        if let userLocation = userLocation {
            let location = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            
            // Calculate driving distance
            calculateDrivingDistance(from: userLocation, to: location) { distance in
                let formattedDistance = String(format: "%.2f", distance)
                
                let formattedPrice = String(format: "%.2f", distance * self.gasPrice * globalCarGasConsumption / 100.0)
                DispatchQueue.main.async {
                    self.distanceLabel.text = "\(formattedDistance) km to location"
                    self.estimatedGasPriceLabel.text = "Estimated Gas Price: \(formattedPrice) TRY"
                }
            }
        }
    }
    
    func fetchGasPrices() {
        gasPriceViewModel.fetchGasPrices(city: "ANKARA") { [weak self] result in
            switch result {
            case .success(let gasPriceInfo):
                if let firstKey = gasPriceInfo.data.keys.first {
                    // Print the first key
                    let gasolineString = firstKey.replacingOccurrences(of: ",", with: ".")
                    self?.gasPrice = Double(gasolineString) ?? 1
                    
                    // Call the combined function after gas price is fetched
                    self?.updateDistanceAndEstimatedPrice()
                } else {
                    print("No data found for the specified key")
                }
                
            case .failure(let error):
                // Handle error
                print("Error fetching gas prices: \(error)")
            }
        }
    }
    
    private func fetchData() {
        //CoreData
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        let idString = selectedTitleID!.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let title = result.value(forKey: "title") as? String {
                        annotationTitle = title
                        
                        if let subtitle = result.value(forKey: "subtitle") as? String {
                            annotationSubtitle = subtitle
                            
                            if let latitude = result.value(forKey: "latitude") as? Double {
                                annotationLatitude = latitude
                                
                                if let longitude = result.value(forKey: "longitude") as? Double {
                                    annotationLongitude = longitude
                                    
                                    let annotation = MKPointAnnotation()
                                    annotation.title = annotationTitle
                                    annotation.subtitle = annotationSubtitle
                                    let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
                                    annotation.coordinate = coordinate
                                    
                                    mapView.addAnnotation(annotation)
                                    nameLabel.text = annotationTitle
                                    commentLabel.text = annotationSubtitle
                                    
                                    locationManager.stopUpdatingLocation()
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    mapView.setRegion(region, animated: true)
                                    
                                    if let userLocation = userLocation {
                                        let location = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
                                        let distance = location.distance(from: userLocation)
                                        let formattedDistance = String(format: "%.2f", distance / 1000)
                                        let formattedPrice = String(format: "%.2f", distance / 1000 / 13 * gasPrice)
                                        
                                        
                                        
                                        DispatchQueue.main.async {
                                            self.distanceLabel.text = "\(formattedDistance) km to location"
                                            self.estimatedGasPriceLabel.text = "Estimated Gas Price: \(formattedPrice) TRY"
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
        
        
        
    }
    
    
    
    private func setupSubViews() {
        [backButton, backgroundImageView, nameLabel, commentLabel, mapView, distanceLabel, estimatedGasPriceLabel
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
            
            nameLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            commentLabel.heightAnchor.constraint(equalToConstant: 40),
            
            
            estimatedGasPriceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            estimatedGasPriceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            estimatedGasPriceLabel.heightAnchor.constraint(equalToConstant: 40),
            estimatedGasPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            estimatedGasPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            distanceLabel.bottomAnchor.constraint(equalTo: estimatedGasPriceLabel.topAnchor, constant: -10),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            distanceLabel.heightAnchor.constraint(equalToConstant: 40),
            distanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            distanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            mapView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 30),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -30)
            
            
        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "LocationListViewController")
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
            
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
        
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            //closure
            
            if let placemark = placemarks {
                if placemark.count > 0 {
                    
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.annotationTitle
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                    
                }
            }
        }
    }
    
}
