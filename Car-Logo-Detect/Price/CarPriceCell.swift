//
//  CarPriceCell.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/2/4.
//

import Foundation
import UIKit
import SnapKit

class CarPriceCell: UICollectionViewCell {
    static let identifier = "carPriceCell"
    
    lazy var makeModelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .green
        contentView.addSubview(makeModelLabel)
        contentView.addSubview(priceLabel)
        
        makeModelLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(makeModelLabel.snp.bottom)
        }
    }
}
