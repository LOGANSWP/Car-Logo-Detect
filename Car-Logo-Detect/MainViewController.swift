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
import ZLPhotoBrowser

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
        
    private lazy var photosButton = FuncButton(funcType: .photos)
    private lazy var drawButton = FuncButton(funcType: .draw)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(mainTitle)
        view.addSubview(aboutButton)
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
        
        photosButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle).offset(300)
            make.width.equalTo(200)
        }
        
        drawButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(photosButton).offset(100)
            make.width.equalTo(200)
        }
    }
    
    private func setupBindings() {
        photosButton.rx.tap
            .subscribe(onNext: {
                let ps = ZLPhotoPreviewSheet()
                ps.selectImageBlock = { [weak self] results, isOriginal in
                    guard let self else { return }
                    present(PreviewViewController(image: results[0].image), animated: true)
                }
                ps.showPhotoLibrary(sender: self)
            })
            .disposed(by: disposeBag)
        
        drawButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                navigationController?.pushViewController(DrawViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
