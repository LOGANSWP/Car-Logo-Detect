//
//  CarPriceCollectionViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/2/4.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CarPriceCollectionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Car Price List"
    }
}
