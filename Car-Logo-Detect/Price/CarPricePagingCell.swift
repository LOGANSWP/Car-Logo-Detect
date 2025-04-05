//
//  CarPricePagingCell.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/26.
//

import Foundation
import UIKit
import Parchment
import SnapKit

class CarPricePagingCell: PagingCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        guard let item = pagingItem as? CarPricePagingItem else { return }
        label.text = "\(item.pageNumber)"
        label.textColor = selected ? .white : .gray
        contentView.backgroundColor = selected ? .systemBlue : .systemGray6
    }
}
