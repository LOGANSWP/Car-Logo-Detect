//
//  CarBrandDetailViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/15.
//

import Foundation
import UIKit
import SnapKit

class CarBrandDetailViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .green
        label.font = UIFont.systemFont(ofSize: 36)
        return label
    }()
    
    init(carBrandItem: CarBrandItem) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = carBrandItem.brandName
        countryLabel.text = carBrandItem.originContry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(countryLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(200)
        }
    }
}
