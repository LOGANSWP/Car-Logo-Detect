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
                guard let self else { return }
                setupResultAlert(success: Bool.random())
                guard let resultAlertController else { return }
                present(resultAlertController, animated: true, completion: nil)
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
            make.top.equalToSuperview().offset(50)
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
    
    private func setupResultAlert(success: Bool) {
        if success {
            resultAlertController = UIAlertController(title: "Success",
                                                      message: "BMW", preferredStyle: .alert)
        } else {
            resultAlertController = UIAlertController(title: "Error",
                                                      message: "Please retry", preferredStyle: .alert)
        }
        let returnToHomeAction = UIAlertAction(title: "Return", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        })
        resultAlertController?.addAction(returnToHomeAction)
    }
}
