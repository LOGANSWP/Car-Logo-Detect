//
//  FreeApiAccess.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/16.
//

import Foundation
import UIKit

class FreeApiAccess {
    static let shared = FreeApiAccess()
        
    private init() {}
    
    // https://universe.roboflow.com/g3-32st4/categorize-car-brands
    func recognizeLogo(image: UIImage, completion: @escaping (Double, String) -> Void) {
        // Load Image and Convert to Base64
        let imageData = image.jpegData(compressionQuality: 1)
        let fileContent = imageData?.base64EncodedString()
        let postData = fileContent!.data(using: .utf8)

        // Initialize Inference Server Request with 26tetxE8B5WES41hy1E9, Model, and Model Version
        var request = URLRequest(url: URL(string: "https://classify.roboflow.com/categorize-car-brands/1?api_key=26tetxE8B5WES41hy1E9&name=YOUR_IMAGE.jpg")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData

        // Execute Post Request
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Parse Response to String
            guard let data = data else {
                print("Error: \(String(describing: error))")
                completion(0, "")
                return
            }

            // Convert Response String to Dictionary
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CarInference.self, from: data)
                DispatchQueue.main.async {
                    // Handle decoded data
                    print("Top Prediction: \(result.top) (\(result.confidence))")
                    completion(result.confidence, result.top)
                }
            } catch {
                print(error.localizedDescription)
                completion(0, "")
            }
        }).resume()
    }
}
