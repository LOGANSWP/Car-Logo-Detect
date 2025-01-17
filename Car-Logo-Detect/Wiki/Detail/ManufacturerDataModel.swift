//
//  ManufacturerDataModel.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/17.
//

import Foundation

struct ManufacturerResult: Codable {
    // Some properties maybe nil during the process of parsing JSON
    let Address: String?
    let City: String?
    let StateProvince: String?
    let Country: String?
    let ContactEmail: String?
    let ContactPhone: String?
    let PostalCode: String?
    let Mfr_Name: String?
}

struct ManufacturerResponse: Codable {
    let Results: [ManufacturerResult]
}

class ManufacturerDataModel {
    private var manufacturers: [ManufacturerResult] = []
    
    // Define callback closure
    var onDataLoaded: (([ManufacturerResult]) -> Void)?
    
    init(brandName: String) {
        loadJSONData(brandName: brandName)
    }
    
    private func loadJSONData(brandName: String) {
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/GetManufacturerDetails/\(brandName)?format=json"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request failure: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(ManufacturerResponse.self, from: data)
                
                self.manufacturers = responseObject.Results
                
                // Call callback to notify data loading completion
                DispatchQueue.main.async {
                    self.onDataLoaded?(self.manufacturers)
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }.resume()
    }
}

