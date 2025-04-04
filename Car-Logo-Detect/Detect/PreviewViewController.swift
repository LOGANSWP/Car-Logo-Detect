//
//  PreviewViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/14.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PreviewViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Detect"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 56)
        title.backgroundColor = .clear
        return title
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var detectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "logo.xbox"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .clear
        button.layer.cornerRadius = 64
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self, let image = imageView.image else { return }
                // Test For car logo detect api
                FreeApiAccess.shared.recognizeLogo(image: image) { [weak self] confidence, brand in
                    DispatchQueue.main.async {
                        self?.setupResultAlert(confidence: confidence, brand: brand)
                    }
                }
            })
            .disposed(by: disposeBag)
        return button
    }()
    
    private var resultAlertController: UIAlertController?
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(detectButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
            make.height.equalTo(300)
        }
        
        detectButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.width.height.equalTo(128)
        }
    }
    
    private func setupResultAlert(confidence: Double, brand: String) {
        if confidence >= 0.3 {
            resultAlertController = UIAlertController(title: "Success",
                                                      message: brand, preferredStyle: .alert)
            
            // TODO: - Go to Wiki page and search this brand's info automatically
            let searchBrandAction = UIAlertAction(title: "Search \(brand)'s information", style: .default, handler: { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
                
                let vc = CarBrandCollectionViewController(brand: brand)
                navigationController?.pushViewController(vc, animated: true)
            })
            resultAlertController?.addAction(searchBrandAction)
            
            // TODO: - Go to Price page and search the prices of this brand automatically
            let searchPriceAction = UIAlertAction(title: "Search \(brand)'s prices", style: .default, handler: { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
            })
            resultAlertController?.addAction(searchPriceAction)

            // TODO: - Go to Chatbot page and ask the information of this brand to AI assistant automatically
            let askAIAction = UIAlertAction(title: "Ask \(brand) to AI assistant", style: .default, handler: { [weak self] _ in
                guard let self else { return }
                dismiss(animated: true)
            })
            resultAlertController?.addAction(askAIAction)
        } else {
            resultAlertController = UIAlertController(title: "Error",
                                                      message: "Please retry", preferredStyle: .alert)
        }
        
        guard let resultAlertController else { return }
        
        let returnToHomeAction = UIAlertAction(title: "Return", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        })
        resultAlertController.addAction(returnToHomeAction)
        
        present(resultAlertController, animated: true, completion: nil)
    }
}
