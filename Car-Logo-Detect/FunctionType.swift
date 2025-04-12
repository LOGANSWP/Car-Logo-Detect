//
//  FunctionType.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/13.
//

import Foundation
import UIKit

enum FunctionType {
    case photos
    case draw
    
    var titleName: String {
        switch self {
        case .photos:
            return "Photos"
        case .draw:
            return "Draw"
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .photos:
            return .clear
        case .draw:
            return .clear
        }
    }
}
