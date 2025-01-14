//
//  MainViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/1/4.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var mainTitle: UILabel = {
        let title = UILabel()
        title.text = "Car Logo Detect"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 48)
        title.backgroundColor = .yellow
        return title
    }()
    
    private lazy var aboutButton: UIButton = {
        let button = UIButton()
        button.setTitle("About", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                present(aboutAlertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        return button
    }()
    
    private lazy var aboutAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "Author",
                                message: "Logan Su\nFrom Southeast University\nEmail: LoganSu1025@outlook.com", preferredStyle: .alert)
        let knownAction = UIAlertAction(title: "Known", style: .cancel, handler: nil)
        alertController.addAction(knownAction)
        return alertController
    }()
        
    private lazy var cameraButton = FuncButton(funcType: .camera)
    private lazy var photosButton = FuncButton(funcType: .photos)
    private lazy var drawButton = FuncButton(funcType: .draw)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.delegate = self
        photosButton.delegate = self
        drawButton.delegate = self
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(mainTitle)
        view.addSubview(aboutButton)
        view.addSubview(cameraButton)
        view.addSubview(photosButton)
        view.addSubview(drawButton)
        
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        aboutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle).offset(100)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle).offset(300)
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

extension MainViewController: FuncButtonTapDelegate {
    func tapFuncButton(type: FunctionType) {
        navigationController?.pushViewController(type.gotoViewController.init(), animated: true)
    }
}
