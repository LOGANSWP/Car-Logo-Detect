//
//  PriceDataModel.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/2/6.
//

import Foundation

struct PriceResult: Codable {
    // Some properties maybe nil during the process of parsing JSON
    let displayColor: String?
    let year: Int?
    let make: String?
    let model: String?
    let price: String?
    let priceUnformatted: Int?
    let mileage: String?
    let mileageUnformatted: Int?
    let city: String?
    let lat: Double?
    let lon: Double?
    let primaryPhotoUrl: String?
    let condition: String?
    let createdAt: String?
    let updatedAt: String?
    let dealerName: String?
    let state: String?
    let trim: String?
    let clickoffUrl: String?
    let bodyType: String?
    let bodyStyle: String?
}

struct PriceResponse: Codable {
    let records: [PriceResult]
}

class PriceDataModel {
    private var prices: [PriceResult] = []
        
    // Define callback closure
    var onDataLoaded: (([PriceResult]) -> Void)?
    
    init(make: String, maxPrice: String, minPrice: String, pageNumber: Int) {
        loadJSONData(make: make, maxPrice: maxPrice, minPrice: minPrice, pageNumber: pageNumber)
    }
    
    private func loadJSONData(make: String, maxPrice: String, minPrice: String, pageNumber: Int) {
        // Filter by make, price
        let urlString = "https://auto.dev/api/listings?apikey=\(APIKeys.autoDevAPIKey)&make=\(make)&price_max=\(maxPrice == "♾️" ? "" : maxPrice)&price_min=\(minPrice)&page=\(pageNumber)"

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
                let responseObject = try decoder.decode(PriceResponse.self, from: data)
                
                self.prices = responseObject.records
                
                // Call callback to notify data loading completion
                DispatchQueue.main.async {
                    self.onDataLoaded?(self.prices)
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }.resume()
    }
}
