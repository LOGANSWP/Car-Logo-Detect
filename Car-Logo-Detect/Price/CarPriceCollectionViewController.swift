//
//  CarPriceCollectionViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/2/4.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CarPriceCollectionViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var filteredPriceList: [PriceResult] = []
    
    private var make: String
    private var maxPrice: String
    private var minPrice: String
    private var pageNumber: Int
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10      // The space between each item
        layout.itemSize = CGSize(width: 380, height: 60)  // The size of each item

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(CarPriceCell.self, forCellWithReuseIdentifier: CarPriceCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return collectionView
    }()
    
    init(make: String, maxPrice: String, minPrice: String, pageNumber: Int) {
        self.make = make
        self.maxPrice = maxPrice
        self.minPrice = minPrice
        self.pageNumber = pageNumber
        
        super.init(nibName: nil, bundle: nil)
        
        loadData(make: make, maxPrice: maxPrice, minPrice: minPrice, pageNumber: pageNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Car Price List"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let item = filteredPriceList[indexPath.item]
                present(CarPriceDetailViewController(item: item), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData(make: String, maxPrice: String, minPrice: String, pageNumber: Int) {
        PriceDataModel(make: make, maxPrice: maxPrice, minPrice: minPrice, pageNumber: pageNumber).onDataLoaded = { [weak self] models in
            self?.filteredPriceList = models
            self?.collectionView.reloadData()
        }
    }
    
    // Let `CarPricePagingViewController` update data
    func updateData(newMake: String, newMaxPrice: String, newMinPrice: String) {
        if newMake != make || newMaxPrice != maxPrice || newMinPrice != minPrice {
            make = newMake
            maxPrice = newMaxPrice
            minPrice = newMinPrice
            loadData(make: newMake, maxPrice: maxPrice, minPrice: minPrice, pageNumber: pageNumber)
        }
    }
}

extension CarPriceCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredPriceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarPriceCell.identifier, for: indexPath) as? CarPriceCell else {
            fatalError("Unable to dequeue AlbumCollectionViewCell")
        }
        let item = filteredPriceList[indexPath.item]
        cell.makeModelLabel.text = "\(item.make ?? ""): \(item.model ?? "")"
        cell.priceLabel.text = "\(item.price ?? "")"
        return cell
    }
}
