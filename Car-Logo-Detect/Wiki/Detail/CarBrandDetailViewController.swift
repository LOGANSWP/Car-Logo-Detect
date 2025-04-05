//
//  CarBrandDetailViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/15.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa

class CarBrandDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var brandModelList: [ModelResult] = []
    private var brandManufacturerList: [ManufacturerResult] = []
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var manufacturerTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Manufacturers"
        return label
    }()
    
    private lazy var manufacturerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5      // The space between each item
        layout.itemSize = CGSize(width: 300, height: 30)  // The size of each item

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(CarManufacturerCell.self, forCellWithReuseIdentifier: CarManufacturerCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return collectionView
    }()
    
    private lazy var modelTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Models"
        return label
    }()
    
    private lazy var modelCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5      // The space between each item
        layout.itemSize = CGSize(width: 300, height: 30)  // The size of each item

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(CarModelCell.self, forCellWithReuseIdentifier: CarModelCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return collectionView
    }()
    
    init(vehicleLogoItem: VehicleLogoItem) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = vehicleLogoItem.brandName
        imageView.sd_setImage(with: URL(string: vehicleLogoItem.logoImageInfo.imageURL), placeholderImage: nil, options: [.retryFailed])
        
        ModelDataModel(brandName: vehicleLogoItem.brandName).onDataLoaded = { [weak self] models in
            self?.brandModelList = models
            self?.modelCollectionView.reloadData()
        }
        
        ManufacturerDataModel(brandName: vehicleLogoItem.brandName).onDataLoaded = { [weak self] manufacturers in
            self?.brandManufacturerList = manufacturers
            self?.manufacturerCollectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update the contentSize of the scrollView based on the total height of its subviews
        // Ensure contentSize is updated after layout is done
        DispatchQueue.main.async { [weak self] in
            let titleLabelHeight = self?.titleLabel.frame.height ?? 0
            let imageViewHeight = self?.imageView.frame.height ?? 0
            let modelCollectionViewHeight = self?.modelCollectionView.frame.height ?? 0
            let manufacturerCollectionViewHeight = self?.manufacturerCollectionView.frame.height ?? 0
            let extraHeight: CGFloat = 300 // Additional spacing
            
            let contentHeight = titleLabelHeight + imageViewHeight + modelCollectionViewHeight + manufacturerCollectionViewHeight + extraHeight
            
            self?.scrollView.contentSize = CGSize(width: self?.view.frame.width ?? 0, height: contentHeight)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imageView)
        scrollView.addSubview(manufacturerTitleLabel)
        scrollView.addSubview(manufacturerCollectionView)
        scrollView.addSubview(modelTitleLabel)
        scrollView.addSubview(modelCollectionView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        
        manufacturerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        manufacturerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(manufacturerTitleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(300)
        }
        
        modelTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(manufacturerCollectionView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        modelCollectionView.snp.makeConstraints { make in
            make.top.equalTo(modelTitleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(30)
            make.height.equalTo(300)
        }
    }
    
    private func setupBindings() {
        manufacturerCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let item = brandManufacturerList[indexPath.item]
                present(ManufacturerViewController(item: item), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension CarBrandDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == manufacturerCollectionView {
            return brandManufacturerList.count
        } else if collectionView == modelCollectionView {
            return brandModelList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == manufacturerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarManufacturerCell.identifier, for: indexPath) as? CarManufacturerCell else {
                fatalError("Unable to dequeue CarManufacturerCell")
            }
            cell.titleLabel.text = brandManufacturerList[indexPath.item].Mfr_Name
            return cell
        } else if collectionView == modelCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarModelCell.identifier, for: indexPath) as? CarModelCell else {
                fatalError("Unable to dequeue CarModelCell")
            }
            cell.titleLabel.text = brandModelList[indexPath.item].Model_Name
            return cell
        }
        fatalError("Unknown collection view")
    }
}
