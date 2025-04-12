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
    
    private lazy var carSign: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "car"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.isEnabled = false
        return button
    }()

    private lazy var mainTitle: UILabel = {
        let title = UILabel()
        title.text = "Car Logo Detect"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 41)
        title.backgroundColor = .clear
        title.textColor = .systemBlue
        return title
    }()
    
    private lazy var aboutButton: UIButton = {
        let button = UIButton()
        button.setTitle("About", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
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
    
    private lazy var wikiButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.layer.cornerRadius = 32
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "dollarsign.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.layer.cornerRadius = 32
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private lazy var aiButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.layer.cornerRadius = 32
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(carSign)
        view.addSubview(mainTitle)
        view.addSubview(aboutButton)
        view.addSubview(photosButton)
        view.addSubview(drawButton)
        view.addSubview(wikiButton)
        view.addSubview(priceButton)
        view.addSubview(aiButton)
        
        carSign.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(128)
            make.width.equalTo(150)
        }
        
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(carSign.snp.bottom).offset(75)
            make.width.equalTo(300)
        }
        
        aboutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle).offset(100)
        }
        
        photosButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitle).offset(200)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        drawButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(photosButton).offset(100)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        wikiButton.snp.makeConstraints { make in
            make.leading.equalTo(drawButton)
            make.top.equalTo(drawButton).offset(100)
            make.width.height.equalTo(64)
        }
        
        priceButton.snp.makeConstraints { make in
            make.trailing.equalTo(drawButton)
            make.top.equalTo(wikiButton)
            make.width.height.equalTo(64)
        }
        
        aiButton.snp.makeConstraints { make in
            make.centerX.equalTo(drawButton)
            make.top.equalTo(wikiButton)
            make.width.height.equalTo(64)
        }
    }
    
    private func setupBindings() {
        aboutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                present(aboutAlertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        photosButton.rx.tap
            .subscribe(onNext: {
                let ps = ZLPhotoPreviewSheet()
                ps.selectImageBlock = { [weak self] results, isOriginal in
                    guard let self else { return }
                    //present(PreviewViewController(image: results[0].image), animated: true)
                    navigationController?.pushViewController(PreviewViewController(image: results[0].image), animated: true)
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
        
        wikiButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                navigationController?.pushViewController(CarBrandCollectionViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        priceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                navigationController?.pushViewController(CarPricePagingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        aiButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                navigationController?.pushViewController(AIAssistantViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
