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

class CarBrandDetailViewController: UIViewController {
    private var brandModellist: [ModelResult] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .yellow
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .gray
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5      // The space between each item
        layout.itemSize = CGSize(width: 300, height: 30)  // The size of each item

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .red
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
            self?.brandModellist = models
            self?.collectionView.reloadData()
        }
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
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(50)
        }
    }
}

extension CarBrandDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandModellist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarModelCell.identifier, for: indexPath) as? CarModelCell else {
            fatalError("Unable to dequeue AlbumCollectionViewCell")
        }
        cell.titleLabel.text = brandModellist[indexPath.item].Model_Name
        return cell
    }
}
