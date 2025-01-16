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
    
    func realFetchAccessToken() {
        let clientID = "H58wSE1EQjgu5w5BbU9ZpgbE" // 替换为您的 AK
        let clientSecret = "1zxriRG10H9sSPVNt5Pb5Ex1ogQyHlwe" // 替换为您的 SK
        fetchAccessToken(clientID: clientID, clientSecret: clientSecret)
    }
    
    func realRecognizeCar(image: UIImage?) {
        guard let image else { return }
        let accessToken = "24.a824ea8965a8f9a1bc872824cdf5014b.2592000.1739603717.282335-25406556" // 替换为通过鉴权接口获取的 access token
        recognizeCar(image: image, accessToken: accessToken)
    }
    
    private func fetchAccessToken(clientID: String, clientSecret: String) {
        let host = "https://aip.baidubce.com/oauth/2.0/token"
        let queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret)
        ]
        
        var urlComponents = URLComponents(string: host)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to fetch token")
                return
            }
            
            if let content = String(data: data, encoding: .utf8) {
                print("Response: \(content)")
            }
        }
        
        task.resume()
    }

    private func recognizeCar(image: UIImage, accessToken: String, topNum: Int = 5) {
        let requestURL = "https://aip.baidubce.com/rest/2.0/image-classify/v1/car?access_token=\(accessToken)"
        
        // 将 UIImage 转换为 Base64 编码
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert UIImage to JPEG data")
            return
        }
        let base64Image = imageData.base64EncodedString()
        
        // 构造请求参数
        let parameters: [String: Any] = [
            "image": base64Image,
            "top_num": topNum
        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Failed to encode parameters")
            return
        }
        
        // 创建请求
        guard let url = URL(string: requestURL) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        // 发送请求
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Request failed")
                return
            }
            
            // 打印响应结果
            if let content = String(data: data, encoding: .utf8) {
                print("Response: \(content)")
            }
        }
        task.resume()
    }
}
