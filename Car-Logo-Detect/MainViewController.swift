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
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Camera", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .blue
        return button
    }()
    
    private lazy var photosButton: UIButton = {
        let button = UIButton()
        button.setTitle("Photos", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .brown
        return button
    }()
    
    private lazy var drawButton: UIButton = {
        let button = UIButton()
        button.setTitle("Draw", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
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
    
    private func setupBindings() {
        cameraButton.rx.tap
            .subscribe(onNext: {
                print("Tap Camera Button")
            })
            .disposed(by: disposeBag)
        
        photosButton.rx.tap
            .subscribe(onNext: {
                print("Tap Photos Button")
            })
            .disposed(by: disposeBag)
        
        drawButton.rx.tap
            .subscribe(onNext: {
                print("Tap Draw Button")
            })
            .disposed(by: disposeBag)
    }
}
