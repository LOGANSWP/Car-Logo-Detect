//
//  FunctionType.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/13.
//

import Foundation
import UIKit

enum FunctionType {
    case camera
    case photos
    case draw
    
    var titleName: String {
        switch self {
        case .camera:
            return "Camera"
        case .photos:
            return "Photos"
        case .draw:
            return "Draw"
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .camera:
            return .blue
        case .photos:
            return .brown
        case .draw:
            return .red
        }
    }
    
    var gotoViewController: UIViewController.Type {
        switch self {
        case .camera:
            return CameraViewController.self
        case .photos:
            return PhotosViewController.self
        case .draw:
            return DrawViewController.self
        }
    }
    
    var tempPrintContent: String {
        switch self {
        case .camera:
            return "Tap Camera Button"
        case .photos:
            return "Tap Photos Button"
        case .draw:
            return "Tap Draw Button"
        }
    }
}

