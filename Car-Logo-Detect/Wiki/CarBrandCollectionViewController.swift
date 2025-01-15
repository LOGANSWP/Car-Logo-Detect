//
//  CarBrandCollectionViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/15.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CarBrandCollectionViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private var carBrandlist: [CarBrandItem] = []
    private var filteredBrandlist: [CarBrandItem] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search by brand name"
        return searchBar
    }()
    
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
        filteredBrandlist = carBrandlist // Initially display all the brands
        setupViews()
        setupBindings()
        
        // Add tap gesture to hide the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allow tap event to continue passing
        view.addGestureRecognizer(tapGesture)
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
        let brand9 = CarBrandItem(brandName: "Maserati", originContry: "Italy")
        let brand10 = CarBrandItem(brandName: "Bentley", originContry: "Uk")
        carBrandlist.append(contentsOf: [brand1, brand2, brand3, brand4, brand5, brand6, brand7, brand8, brand9, brand10])
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Car Brand Wiki"
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        // Observe the input of search bar
        searchBar.rx.text.orEmpty
            .distinctUntilChanged() // Avoid repeating
            .subscribe(onNext: { [weak self] query in
                guard let self else { return }
                filteredBrandlist = self.carBrandlist.filter { brand in
                    query.isEmpty || brand.brandName.lowercased().contains(query.lowercased())
                }
                collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                searchBar.resignFirstResponder() // Hide the keyboard
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                let item = filteredBrandlist[indexPath.item]
                present(CarBrandDetailViewController(carBrandItem: item), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CarBrandCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredBrandlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarBrandCell.identifier, for: indexPath) as? CarBrandCell else {
            fatalError("Unable to dequeue AlbumCollectionViewCell")
        }
        cell.titleLabel.text = filteredBrandlist[indexPath.item].brandName
        return cell
    }
}
