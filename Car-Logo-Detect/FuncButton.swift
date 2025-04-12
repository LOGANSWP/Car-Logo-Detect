//
//  FuncButton.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FuncButton: UIButton {
    private let disposeBag = DisposeBag()
        
    init(funcType: FunctionType, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setTitle(funcType.titleName, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 24)
        self.backgroundColor = funcType.bgColor
        self.setTitleColor(.systemBlue, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
