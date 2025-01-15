//
//  CarBrandCell.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/15.
//

import Foundation
import UIKit
import SnapKit

class CarBrandCell: UICollectionViewCell {
    static let identifier = "carBrandCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
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
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
