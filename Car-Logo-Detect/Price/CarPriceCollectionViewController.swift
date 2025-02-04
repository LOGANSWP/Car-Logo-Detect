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
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20      // The space between each item
        layout.itemSize = CGSize(width: 300, height: 75)  // The size of each item

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .red
        collectionView.dataSource = self
        collectionView.register(CarPriceCell.self, forCellWithReuseIdentifier: CarPriceCell.identifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Car Price List"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
    }
}

extension CarPriceCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarPriceCell.identifier, for: indexPath) as? CarPriceCell else {
            fatalError("Unable to dequeue AlbumCollectionViewCell")
        }
        return cell
    }
}
