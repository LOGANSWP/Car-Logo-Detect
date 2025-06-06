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
import iOSDropDown

class CarPricePagingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter car make"
        return searchBar
    }()
    
    private let maxPriceDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.optionArray = ["10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "♾️"]
        dropDown.placeholder = "Select a max price $"
        dropDown.isSearchEnable = false
        dropDown.cornerRadius = 8
        dropDown.layer.masksToBounds = true
        dropDown.arrowColor = .clear
        dropDown.backgroundColor = .systemGray6
        dropDown.selectedRowColor = .lightGray
        dropDown.textAlignment = .center
        dropDown.listHeight = 330
        return dropDown
    }()
    
    private let minPriceDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.optionArray = ["0", "10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000"]
        dropDown.placeholder = "Select a min price $"
        dropDown.isSearchEnable = false
        dropDown.cornerRadius = 8
        dropDown.layer.masksToBounds = true
        dropDown.arrowColor = .clear
        dropDown.backgroundColor = .systemGray6
        dropDown.selectedRowColor = .lightGray
        dropDown.textAlignment = .center
        dropDown.listHeight = 330
        return dropDown
    }()
    
    private lazy var priceErrorAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "Price Error",
                                message: "Min price should be always lower than or equal to Max price.", preferredStyle: .alert)
        let knownAction = UIAlertAction(title: "Known", style: .cancel, handler: nil)
        alertController.addAction(knownAction)
        return alertController
    }()
    
    private let pagingViewController = PagingViewController()
    private var currentSearchText: String = ""
    private var currentMaxPrice: String = ""
    private var currentMinPrice: String = ""
    
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
        
        pagingViewController.indicatorOptions = .hidden
        pagingViewController.borderOptions = .hidden
        
        addChild(pagingViewController)
        view.addSubview(searchBar)
        view.addSubview(minPriceDropDown)
        view.addSubview(maxPriceDropDown)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(16)
        }
        
        minPriceDropDown.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(23)
            make.height.equalTo(50)
            make.width.equalTo(180)
        }
        
        maxPriceDropDown.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(23)
            make.height.equalTo(50)
            make.width.equalTo(180)
        }
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(minPriceDropDown.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalTo(minPriceDropDown)
            make.right.equalTo(maxPriceDropDown)
        }
        
        setupSearchBinding()
        
        maxPriceDropDown.didSelect { [weak self] selectedText, index, id in
            guard let self else { return }
            self.currentMaxPrice = selectedText
            reloadCurrentPage()
            
            // Get current visible CarPriceCollectionViewController
            if let currentVC = pagingViewController.pageViewController.selectedViewController as? CarPriceCollectionViewController {
                currentVC.updateData(newMake: self.searchBar.text ?? "", newMaxPrice: self.maxPriceDropDown.text ?? "", newMinPrice: self.minPriceDropDown.text ?? "")
            }
            
            priceErrorCheck(minPrice: self.currentMinPrice, maxPrice: self.currentMaxPrice)
        }

        minPriceDropDown.didSelect { [weak self] selectedText, index, id in
            guard let self else { return }
            self.currentMinPrice = selectedText
            reloadCurrentPage()
            
            // Get current visible CarPriceCollectionViewController
            if let currentVC = pagingViewController.pageViewController.selectedViewController as? CarPriceCollectionViewController {
                currentVC.updateData(newMake: self.searchBar.text ?? "", newMaxPrice: self.maxPriceDropDown.text ?? "", newMinPrice: self.minPriceDropDown.text ?? "")
            }
            
            priceErrorCheck(minPrice: self.currentMinPrice, maxPrice: self.currentMaxPrice)
        }
        
        // Add tap gesture to hide the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allow tap event to continue passing
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Search init brand automatically
        if !hasPerformedInitialSearch, let brand = initialBrand {
            hasPerformedInitialSearch = true
            searchBar.text = brand
            currentSearchText = brand
            searchBar.resignFirstResponder()
            reloadCurrentPage()

            // Proactively notify the current page to refresh the content
            if let currentVC = pagingViewController.pageViewController.selectedViewController as? CarPriceCollectionViewController {
                currentVC.updateData(newMake: brand, newMaxPrice: "", newMinPrice: "")
            }
        }
    }
    
    private func setupSearchBinding() {
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.currentSearchText = searchBar.text ?? ""
                self.searchBar.resignFirstResponder() // Turn off keyboard
                reloadCurrentPage()
                
                // Get current visible CarPriceCollectionViewController
                if let currentVC = pagingViewController.pageViewController.selectedViewController as? CarPriceCollectionViewController {
                    currentVC.updateData(newMake: self.searchBar.text ?? "", newMaxPrice: self.maxPriceDropDown.text ?? "", newMinPrice: self.minPriceDropDown.text ?? "")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadCurrentPage() {
        let currentItem = pagingViewController.state.currentPagingItem
        if let item = currentItem as? CarPricePagingItem {
            // Force to recreate and setup current page
            pagingViewController.reloadData(around: item)
        }
    }
    
    private func priceErrorCheck(minPrice: String, maxPrice: String) {
        // Infinite price never wrong
        if maxPrice == "♾️" {
            return
        }
        
        guard let min = Int(minPrice), let max = Int(maxPrice) else {
            return
        }
        if min > max {
            present(priceErrorAlertController, animated: true, completion: nil)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
        return CarPriceCollectionViewController(make: currentSearchText, maxPrice: currentMaxPrice, minPrice: currentMinPrice, pageNumber: carPricePagingItem.pageNumber)
    }
}
