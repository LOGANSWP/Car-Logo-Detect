//
//  LogoDataModel.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/16.
//

import Foundation

// Define model
struct VehicleLogoItem: Codable {
    let brandName: String
    let logoImageInfo: LogoImageInfo
    
    // Map the properties of model to the properties of JSON
    enum CodingKeys: String, CodingKey {
        case brandName = "name"
        case logoImageInfo = "logotype"
    }
}

struct LogoImageInfo: Codable {
    let imageURL: String
    
    // Map the properties of model to the properties of JSON
    enum CodingKeys: String, CodingKey {
        case imageURL = "uri"
    }
}

class LogoDataModel {
    lazy var logoData = {
        let data = LogoDataModel().logos
        return data
    }()
    
    private var logos: [VehicleLogoItem] = []
    
    init() {
        loadJSONData()
    }
    
    private func loadJSONData() {
        guard let url = Bundle.main.url(forResource: "vehicle-logotypes", withExtension: "json") else {
            print("Cannot find vehicle-logotypes.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            // The top-level structure of vehicle-logotypes.json is a dictionary rather than an array, So decode as [String: VehicleLogotypes]
            let decodedData = try decoder.decode([String: VehicleLogoItem].self, from: data)
            // Extract values as an array
            logos = Array(decodedData.values)
        } catch {
            print("Failed to parse JSON file: \(error)")
        }
    }
}
