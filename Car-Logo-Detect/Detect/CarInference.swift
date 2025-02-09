//
//  CarInference.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/2/9.
//

import Foundation

// MARK: - Main structure
struct CarInference: Codable {
    let inferenceID: String
    let time: Double
    let image: ImageInfo
    let predictions: [Prediction]
    let top: String
    let confidence: Double

    // JSON key mapping
    enum CodingKeys: String, CodingKey {
        case inferenceID = "inference_id"
        case time
        case image
        case predictions
        case top
        case confidence
    }
}

// MARK: - Image information
struct ImageInfo: Codable {
    let width: Int
    let height: Int
}

// MARK: - prediction item
struct Prediction: Codable {
    let className: String
    let classID: Int
    let confidence: Double

    enum CodingKeys: String, CodingKey {
        case className = "class"
        case classID = "class_id"
        case confidence
    }
}
