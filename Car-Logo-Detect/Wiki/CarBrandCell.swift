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
        label.backgroundColor = .systemGray6
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
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Touch Feedback Animations
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateDown()
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateUp()
        super.touchesEnded(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateUp()
        super.touchesCancelled(touches, with: event)
    }
    
    private func animateDown() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.titleLabel.backgroundColor = UIColor.systemGray4
        })
    }

    private func animateUp() {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.transform = CGAffineTransform.identity
            self.titleLabel.backgroundColor = UIColor.systemGray6
        })
    }
}
