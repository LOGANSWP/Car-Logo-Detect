//
//  CarInfoWikiViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/15.
//

import Foundation
import UIKit
import SnapKit

class CarInfoWikiViewController: UIViewController {
    private var carBrandlist: [CarBrandItem] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20      // The space between each item
        layout.itemSize = CGSize(width: 300, height: 75)  // The size of each item

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.register(CarBrandCell.self, forCellWithReuseIdentifier: CarBrandCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configBrandlist()
        setupViews()
    }
    
    private func configBrandlist() {
        let brand1 = CarBrandItem(brandName: "Benz", originContry: "Germany")
        let brand2 = CarBrandItem(brandName: "Tesla", originContry: "USA")
        let brand3 = CarBrandItem(brandName: "Toyata", originContry: "Japan")
        let brand4 = CarBrandItem(brandName: "BYD", originContry: "China")
        let brand5 = CarBrandItem(brandName: "Rolls-Royce", originContry: "UK")
        let brand6 = CarBrandItem(brandName: "Audi", originContry: "Germany")
        let brand7 = CarBrandItem(brandName: "Honda", originContry: "Japan")
        let brand8 = CarBrandItem(brandName: "Ferrari", originContry: "Italy")
        carBrandlist.append(contentsOf: [brand1, brand2, brand3, brand4, brand5, brand6, brand7, brand8])
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}

extension CarInfoWikiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carBrandlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarBrandCell.identifier, for: indexPath) as? CarBrandCell else {
            fatalError("Unable to dequeue AlbumCollectionViewCell")
        }
        cell.titleLabel.text = carBrandlist[indexPath.item].brandName
        return cell
    }
}
