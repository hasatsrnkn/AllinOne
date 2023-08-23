//
//  CurrencyViewController.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 5.08.2023.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    let backButton = BackButtonSingleton.shared.backButton
    let currencyViewModel = CurrencyViewModel()
    let gasPriceViewModel = GasPriceViewModel()
    
    let backgroundImageView = BackgroundImage(systemName: "currency_background")
    
    let usdImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "dollarsign")
        image.contentMode = .scaleToFill
        image.tintColor = .white
        return image
    }()
    
    let usdLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    let euroImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "eurosign")
        image.contentMode = .scaleToFill
        image.tintColor = .white
        return image
    }()
    
    let euroLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    let gbpImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "sterlingsign")
        image.contentMode = .scaleToFill
        image.tintColor = .white
        return image
    }()
    
    let gbpLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    let gasolineImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "car")
        image.contentMode = .scaleToFill
        image.tintColor = .white
        return image
    }()
    
    let gasolineLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    let gasFuelTank : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "\(globalCarName) Fill-Up: Loading..."
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
    
    let noAPIErrorLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "There Is No API Key"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSubViews()
        setupLayouts()
        setupActions()
        fetchExchangeRates()
        fetchGasPrices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGlobalVariables()
        updateUIViews()
    }
    
    func updateUIViews() {
        if (globalApiKey == "") {
            euroImageView.isHidden = true
            euroLabel.isHidden = true
            usdImageView.isHidden = true
            gbpImageView.isHidden = true
            usdLabel.isHidden = true
            gbpLabel.isHidden = true
            
            view.addSubview(noAPIErrorLabel)
            
            NSLayoutConstraint.activate([
                noAPIErrorLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 60),
                noAPIErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                noAPIErrorLabel.heightAnchor.constraint(equalToConstant: 40),
                
            ])
        }
        if (globalCarName == "") {
            gasolineLabel.isHidden = true
            gasolineImageView.isHidden = true
            gasFuelTank.isHidden = true
            
            view.addSubview(noCarErrorLabel)
            
            NSLayoutConstraint.activate([
                noCarErrorLabel.topAnchor.constraint(equalTo: gbpLabel.bottomAnchor, constant: 45),
                noCarErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                noCarErrorLabel.heightAnchor.constraint(equalToConstant: 40),
                
            ])
        }
        
    }
    
    func fetchGasPrices() {
        gasPriceViewModel.fetchGasPrices(city: "ANKARA") { [weak self] result in
            switch result {
            case .success(let gasPriceInfo):
                if let firstKey = gasPriceInfo.data.keys.first {
                    // Print the first key
                    let gasolineString = firstKey.replacingOccurrences(of: ",", with: ".")
                    let numericValue = Double(gasolineString)
                    let gasolinePrice = String(gasolineString) + " TRY"
                    let depoDolumu: Double = (numericValue ?? 1) * Double(globalCarFuelTank)
                    print(firstKey)
                    
                    DispatchQueue.main.async {
                        self?.gasolineLabel.text = "Gas: \(gasolinePrice)"
                        self?.gasFuelTank.text = "\(globalCarName) Fill-Up: \(String(format: "%.2f", depoDolumu)) TRY"
                    }
                } else {
                    print("No data found for the specified key")
                }
                
            case .failure(let error):
                // Handle error
                print("Error fetching gas prices: \(error)")
            }
        }
    }





    /*
    func fetchGasPrices() {
        gasPriceViewModel.fetchGasPrices { [weak self] result in
            switch result {
            case .success(let gasPriceInfo):
                if let firstGas = gasPriceInfo.result.first {
                    let gasolinePrice: String
                    var depoDolumu : Double = 0.0
                    if let benzin = firstGas.benzin {
                        gasolinePrice = String(format: "%.2f", benzin) + " TRY"
                        depoDolumu = benzin * 45
                    } else {
                        gasolinePrice = "Data not available"
                    }
                    
                    DispatchQueue.main.async {
                        self?.gasolineLabel.text = "Gas: \(gasolinePrice)"
                        self?.jeepRenegadeDepo.text = "Jeep Fill-Up: \(String(format: "%.2f", depoDolumu)) TRY"
                    }
                } else {
                    print("No gas price data found in the array.")
                }
            case .failure(let error):
                // Handle error
                print("Error fetching gas prices: \(error)")
            }
        }
    }
    */
    func fetchExchangeRates() {
        currencyViewModel.fetchExchangeRates { [weak self] error in
            if let error = error {
                // Handle error
                print("Error fetching exchange rates: \(error)")
            } else {
                // Print the fetched data
                if let exchangeRates = self?.currencyViewModel.exchangeRates?.data {
                    for currency in exchangeRates {
                        if currency.value.code == "EUR" {
                            let currencyValue = 1.0 / currency.value.value
                            DispatchQueue.main.async {
                                self?.euroLabel.text = "EUR = \(String(format: "%.4f", currencyValue))"
                            }
                        } else if currency.value.code == "USD" {
                            let currencyValue = 1.0 / currency.value.value
                            DispatchQueue.main.async {
                                self?.usdLabel.text = "USD = \(String(format: "%.4f", currencyValue))"
                            }
                        } else if currency.value.code == "GBP" {
                            let currencyValue = 1.0 / currency.value.value
                            DispatchQueue.main.async {
                                self?.gbpLabel.text = "GBP = \(String(format: "%.4f", currencyValue))"
                            }
                        }
                        
                        print("Currency Code: \(currency.value.code), Value: \(currency.value.value)")
                    }
                }
            }
        }
    }
    
    private func setupSubViews() {
        [backButton,  euroImageView, euroLabel, usdImageView, gbpImageView, usdLabel, gbpLabel,backgroundImageView, gasolineLabel,gasolineImageView,gasFuelTank
        ].forEach { (item) in
            view.addSubview(item)
        }
    }
    
    private func setupLayouts() {
        /*
        let stackView = UIStackView(arrangedSubviews: [euroImageView, euroLabel, usdImageView, usdLabel, gbpImageView, gbpLabel,gasolineImageView,gasolineLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        
        view.addSubview(stackView)
        */
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            //
            euroImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            euroImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            euroImageView.widthAnchor.constraint(equalToConstant: 100),
            euroImageView.heightAnchor.constraint(equalToConstant: 100),
            
            euroLabel.topAnchor.constraint(equalTo: euroImageView.bottomAnchor, constant: 15),
            euroLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            euroLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            euroLabel.heightAnchor.constraint(equalToConstant: 25),
            
            usdImageView.topAnchor.constraint(equalTo: euroLabel.bottomAnchor, constant: 15),
            usdImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            usdImageView.widthAnchor.constraint(equalToConstant: 100),
            usdImageView.heightAnchor.constraint(equalToConstant: 100),
            
            usdLabel.topAnchor.constraint(equalTo: usdImageView.bottomAnchor, constant: 15),
            usdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            usdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            usdLabel.heightAnchor.constraint(equalToConstant: 25),
            
            gbpImageView.topAnchor.constraint(equalTo: usdLabel.bottomAnchor, constant: 15),
            gbpImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            gbpImageView.widthAnchor.constraint(equalToConstant: 100),
            gbpImageView.heightAnchor.constraint(equalToConstant: 100),
            
            gbpLabel.topAnchor.constraint(equalTo: gbpImageView.bottomAnchor, constant: 15),
            gbpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gbpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            gbpLabel.heightAnchor.constraint(equalToConstant: 25),
            
            gasolineImageView.topAnchor.constraint(equalTo: gbpLabel.bottomAnchor, constant: 15),
            gasolineImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            gasolineImageView.widthAnchor.constraint(equalToConstant: 100),
            gasolineImageView.heightAnchor.constraint(equalToConstant: 100),
            
            gasolineLabel.topAnchor.constraint(equalTo: gasolineImageView.bottomAnchor, constant: 15),
            gasolineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gasolineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            gasolineLabel.heightAnchor.constraint(equalToConstant: 25),
             
             /*
            
            stackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Adjust the image view heights here
            euroImageView.heightAnchor.constraint(equalToConstant: 100),
            euroImageView.widthAnchor.constraint(equalToConstant: 150),
            
            usdImageView.heightAnchor.constraint(equalToConstant: 100),
            usdImageView.widthAnchor.constraint(equalToConstant: 150),
            
            gbpImageView.heightAnchor.constraint(equalToConstant: 100),
            gbpImageView.widthAnchor.constraint(equalToConstant: 150),
            
            gasolineImageView.heightAnchor.constraint(equalToConstant: 100),
            gasolineImageView.widthAnchor.constraint(equalToConstant: 150),
            
            // Additional constraints for labels
            euroLabel.heightAnchor.constraint(equalToConstant: 25),
            
            usdLabel.heightAnchor.constraint(equalToConstant: 25),
            
            gbpLabel.heightAnchor.constraint(equalToConstant: 25),
            
            gasolineLabel.heightAnchor.constraint(equalToConstant: 25),
            */
            
            gasFuelTank.topAnchor.constraint(equalTo: gasolineLabel.bottomAnchor, constant: 5),
            gasFuelTank.heightAnchor.constraint(equalToConstant: 25),
            gasFuelTank.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gasFuelTank.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            
        ])
    }
    
    private func setupActions() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
        backButton.addGestureRecognizer(backButtonGesture)
    }
    
    @objc func backButtonClicked() {
        print("back clicked")
        DispatchQueue.main.async {
            self.navigateToNextViewController(viewController: "MainMenuViewController")
        }
    }
}
