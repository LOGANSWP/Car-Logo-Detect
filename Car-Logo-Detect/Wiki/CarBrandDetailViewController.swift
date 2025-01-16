//
//  CarBrandDetailViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/15.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

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
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    init(vehicleLogoItem: VehicleLogoItem) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = vehicleLogoItem.brandName
        imageView.sd_setImage(with: URL(string: vehicleLogoItem.logoImageInfo.imageURL), placeholderImage: nil, options: [.retryFailed])
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
        view.addSubview(imageView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(countryLabel.snp.bottom).offset(100)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}
