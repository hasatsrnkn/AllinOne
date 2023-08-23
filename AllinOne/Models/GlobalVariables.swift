//
//  GlobalVariables.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 23.08.2023.
//


import Foundation

var globalCarName: String = "Jeep"
var globalCarFuelTank: Int = 45
var globalCarGasConsumption: Double = 7.9
var globalApiKey: String = ""

func setGlobalVariables() {
    if let carName = UserDefaults.standard.string(forKey: "CarName") {
        globalCarName = carName
        print(globalCarName)
    }
    
    if let fuelCapacity = UserDefaults.standard.value(forKey: "CarFuelCapacity") as? Int {
        globalCarFuelTank = fuelCapacity
        print(globalCarFuelTank)

    }
    
    if let gasConsumption = UserDefaults.standard.value(forKey: "CarGasConsumption") as? Double {
        globalCarGasConsumption = gasConsumption
        print(globalCarGasConsumption)
    }
    
    if let apiKey = UserDefaults.standard.string(forKey: "ApiKey") {
        globalApiKey = apiKey
        print(globalApiKey)

    }
    print("global variables are set")
}

