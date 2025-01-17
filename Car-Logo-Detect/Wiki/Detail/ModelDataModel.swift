//
//  ModelDataModel.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/17.
//

import Foundation

// 定义返回的数据结构
struct ModelResult: Codable {
    let Model_Name: String
}

struct Response: Codable {
    let Results: [ModelResult]
}

class ModelDataModel {
    private var models: [ModelResult] = []
    
    // Define callback closure
    var onDataLoaded: (([ModelResult]) -> Void)?
    
    init(brandName: String) {
        loadJSONData(brandName: brandName)
    }
    
    private func loadJSONData(brandName: String) {
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMake/\(brandName)?format=json"

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
                let responseObject = try decoder.decode(Response.self, from: data)
                
                self.models = responseObject.Results
                
                // Call callback to notify data loading completion
                DispatchQueue.main.async {
                    self.onDataLoaded?(self.models)
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }.resume()
    }
}
