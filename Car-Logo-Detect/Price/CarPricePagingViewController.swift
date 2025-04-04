//
//  CarPricePagingViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/26.
//

import Foundation
import UIKit
import SnapKit
import Parchment
import RxCocoa
import RxSwift

class CarPricePagingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter car make"
        return searchBar
    }()
    
    private let pagingViewController = PagingViewController()
    private var currentSearchText: String = ""
    
    private var initialBrand: String?
    
    private var hasPerformedInitialSearch = false

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(brand: String) {
        self.init()
        self.initialBrand = brand
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pagingViewController.register(CarPricePagingCell.self, for: CarPricePagingItem.self)
        pagingViewController.menuItemSize = .fixed(width: 40, height: 40)
        pagingViewController.menuItemSpacing = 10
        pagingViewController.menuBackgroundColor = .clear
        pagingViewController.infiniteDataSource = self
        pagingViewController.select(pagingItem: CarPricePagingItem(pageNumber: 1))
        
        addChild(pagingViewController)
        view.addSubview(searchBar)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(16)
        }
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        setupSearchBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Search init brand automatically
        if !hasPerformedInitialSearch, let brand = initialBrand {
            hasPerformedInitialSearch = true
            searchBar.text = brand
            currentSearchText = brand
            searchBar.resignFirstResponder()

            // Proactively notify the current page to refresh the content
            if let currentVC = pagingViewController.pageViewController.selectedViewController as? CarPriceCollectionViewController {
                currentVC.updateMake(brand)
            }
        }
    }
    
    private func setupSearchBinding() {
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.currentSearchText = searchBar.text ?? ""
                self.searchBar.resignFirstResponder() // Turn off keyboard
                
                // Get current visible CarPriceCollectionViewController
                if let currentVC = pagingViewController.pageViewController.selectedViewController as? CarPriceCollectionViewController {
                    currentVC.updateMake(self.searchBar.text ?? "")
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CarPricePagingViewController: PagingViewControllerInfiniteDataSource {
    func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
        let carPricePagingItem = pagingItem as! CarPricePagingItem
        return CarPricePagingItem(pageNumber: carPricePagingItem.pageNumber + 1)
    }

    func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
        let carPricePagingItem = pagingItem as! CarPricePagingItem
        return carPricePagingItem.pageNumber > 1 ? CarPricePagingItem(pageNumber: carPricePagingItem.pageNumber - 1) : nil
    }
    
    func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) -> UIViewController {
        let carPricePagingItem = pagingItem as! CarPricePagingItem
        return CarPriceCollectionViewController(make: currentSearchText, pageNumber: carPricePagingItem.pageNumber)
    }
}
