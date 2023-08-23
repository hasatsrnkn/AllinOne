//
//  SettingsViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 23.08.2023.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let backButton = BackButtonSingleton.shared.backButton
    
    let backgroundImageView = BackgroundImage(systemName: "settings_background")
    
    let fuelCapacityData = Array(1...80)
    let gasConsumptionData: [Int] = Array(0...200) // Instead of stride
    
    
    
    
    let carLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 22) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.zPosition = 1.0
        
        let iconImage = UIImage(systemName: "car")
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = 12
        iconImageView.layer.masksToBounds = true
        label.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5),
            iconImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        label.text = "Car Settings"
        return label
    }()
    
    let apiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 22) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.zPosition = 1.0
        
        let iconImage = UIImage(systemName: "network")
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.cornerRadius = 12
        iconImageView.layer.masksToBounds = true
        label.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 5),
            iconImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        label.text = "API Settings"
        return label
    }()
    
    let carNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.zPosition = 1.0
        
        label.text = "Car Name"
        return label
    }()
    
    let carNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.textColor = .white
        textField.font = UIFont(name: "Futura", size: 16) ?? UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10 // Adjust the radius value as needed
        textField.layer.masksToBounds = true
        textField.layer.zPosition = 1.0
        
        return textField
    }()
    
    let carFuelTankCapacityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.zPosition = 1.0
        
        label.text = "Fuel Tank Capacity"
        return label
    }()
    
    private lazy var carFuelCapacityPickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let carGasConsumptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.zPosition = 1.0
        
        label.text = "Car Gas Consumption Per 100 Km"
        return label
    }()
    
    private lazy var carGasConsumptionPickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let apiLinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.layer.zPosition = 1.0
        label.textAlignment = .center
        label.text = "API Key for TRY to EUR, USD, GBP"
        return label
    }()
    
    let apiLinkTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.textColor = .white
        textField.font = UIFont(name: "Futura", size: 16) ?? UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 10 // Adjust the radius value as needed
        textField.layer.masksToBounds = true
        textField.layer.zPosition = 1.0
        
        return textField
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGlobalVariables()
        updateUIWithGlobalVariables()
    }
    
    private func setupSubViews() {
        [backButton,backgroundImageView,  apiLabel, apiLinkLabel, apiLinkTextField,carLabel,carNameLabel ,carNameTextField, carFuelTankCapacityLabel, carFuelCapacityPickerView, carGasConsumptionLabel,carGasConsumptionPickerView,
         submitButton,
         
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
            
            apiLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            apiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            apiLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            apiLabel.heightAnchor.constraint(equalToConstant: 40),
            
            apiLinkLabel.topAnchor.constraint(equalTo: apiLabel.bottomAnchor, constant: 10),
            apiLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            apiLinkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            apiLinkLabel.heightAnchor.constraint(equalToConstant: 40),
            
            apiLinkTextField.topAnchor.constraint(equalTo: apiLinkLabel.bottomAnchor, constant: 5),
            apiLinkTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            apiLinkTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            apiLinkTextField.heightAnchor.constraint(equalToConstant: 40),
            
            carLabel.topAnchor.constraint(equalTo: apiLinkTextField.bottomAnchor, constant: 30),
            carLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            carLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            carLabel.heightAnchor.constraint(equalToConstant: 40),
            
            carNameLabel.topAnchor.constraint(equalTo: carLabel.bottomAnchor, constant: 10),
            carNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            carNameLabel.widthAnchor.constraint(equalToConstant: 100),
            carNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            carNameTextField.topAnchor.constraint(equalTo: carLabel.bottomAnchor, constant: 10),
            carNameTextField.leadingAnchor.constraint(equalTo: carNameLabel.trailingAnchor, constant: 10),
            carNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            carNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            carFuelTankCapacityLabel.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: 20),
            carFuelTankCapacityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            carFuelTankCapacityLabel.widthAnchor.constraint(equalToConstant: 170),
            carFuelTankCapacityLabel.centerYAnchor.constraint(equalTo: carFuelCapacityPickerView.centerYAnchor, constant: 0),
            
            carFuelCapacityPickerView.topAnchor.constraint(equalTo: carNameLabel.bottomAnchor, constant: 20),
            carFuelCapacityPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            carFuelCapacityPickerView.heightAnchor.constraint(equalToConstant: 100),
            carFuelCapacityPickerView.widthAnchor.constraint(equalToConstant: 100),
            
            carGasConsumptionLabel.topAnchor.constraint(equalTo: carFuelCapacityPickerView.bottomAnchor, constant: 20),
            carGasConsumptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            carGasConsumptionLabel.widthAnchor.constraint(equalToConstant: 300),
            carGasConsumptionLabel.centerYAnchor.constraint(equalTo: carGasConsumptionPickerView.centerYAnchor, constant: 0),
            
            carGasConsumptionPickerView.topAnchor.constraint(equalTo: carFuelCapacityPickerView.bottomAnchor, constant: 20),
            carGasConsumptionPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            carGasConsumptionPickerView.heightAnchor.constraint(equalToConstant: 100),
            carGasConsumptionPickerView.widthAnchor.constraint(equalToConstant: 100),
            
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.widthAnchor.constraint(equalToConstant: 180)
            
        ])
        
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let submitRecognizer = UITapGestureRecognizer(target: self, action: #selector(submitClicked))
        submitButton.addGestureRecognizer(submitRecognizer)
    }
    
    @objc func submitClicked() {
        UserDefaults.standard.set(carNameTextField.text, forKey: "CarName")
        UserDefaults.standard.set(carFuelCapacityPickerView.selectedRow(inComponent: 0) + 1, forKey: "CarFuelCapacity")
        UserDefaults.standard.set(Double(gasConsumptionData[carGasConsumptionPickerView.selectedRow(inComponent: 0)] ) / 10.0, forKey: "CarGasConsumption")
        UserDefaults.standard.set(apiLinkTextField.text, forKey: "ApiKey")
        
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MainMenuViewController")
        }
    }
    
    func updateUIWithGlobalVariables() {
        carNameTextField.text = globalCarName
        apiLinkTextField.text = globalApiKey
        
        if let fuelTankIndex = fuelCapacityData.firstIndex(of: globalCarFuelTank) {
            carFuelCapacityPickerView.selectRow(fuelTankIndex, inComponent: 0, animated: false)
        }
        
        let originalGasConsumption = Double(globalCarGasConsumption) * 10.0
        if let gasConsumptionIndex = gasConsumptionData.firstIndex(of: Int(originalGasConsumption)) {
            carGasConsumptionPickerView.selectRow(gasConsumptionIndex, inComponent: 0, animated: false)
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
    
    private func gasConsumptionValueForRow(row: Int) -> String {
        let decimalValue = Double(gasConsumptionData[row]) / 10.0
        return String(format: "%.1f", decimalValue)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == carFuelCapacityPickerView {
            return fuelCapacityData.count
        }
        else if pickerView == carGasConsumptionPickerView {
            return gasConsumptionData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == carFuelCapacityPickerView {
            return fuelCapacityData[row].description
        }
        else if pickerView == carGasConsumptionPickerView {
            return gasConsumptionValueForRow(row: row)
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == carFuelCapacityPickerView {
            let selectedOption = fuelCapacityData[row]
            print("Selected option for picker 1: \(selectedOption)")
        }
        if pickerView == carGasConsumptionPickerView {
            let selectedOption = gasConsumptionValueForRow(row: row)
            print("Selected option for picker 2: \(selectedOption)")
        }
    }
    
}
