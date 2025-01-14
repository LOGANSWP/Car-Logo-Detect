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

protocol FuncButtonTapDelegate: AnyObject {
    func tapFuncButton(type: FunctionType)
}

class FuncButton: UIButton {
    private let disposeBag = DisposeBag()
    
    weak var delegate: FuncButtonTapDelegate?
    
    init(funcType: FunctionType, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setTitle(funcType.titleName, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        self.backgroundColor = funcType.bgColor
        
        self.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                print(funcType.tempPrintContent)
                delegate?.tapFuncButton(type: funcType)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
