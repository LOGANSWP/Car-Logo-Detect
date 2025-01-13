//
//  ViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/1/4.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var mainTitle: UILabel = {
        let title = UILabel()
        title.text = "Car Logo Detect"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 32)
        title.backgroundColor = .yellow
        return title
    }()
        
    private lazy var cameraButton = FuncButton(funcType: .camera)
    private lazy var photosButton = FuncButton(funcType: .photos)
    private lazy var drawButton = FuncButton(funcType: .draw)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(mainTitle)
        view.addSubview(cameraButton)
        view.addSubview(photosButton)
        view.addSubview(drawButton)
        
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle).offset(200)
            make.width.equalTo(200)
        }
        
        photosButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cameraButton).offset(100)
            make.width.equalTo(200)
        }
        
        drawButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(photosButton).offset(100)
            make.width.equalTo(200)
        }
    }
}
