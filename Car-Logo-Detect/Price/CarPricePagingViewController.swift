//
//  CarPricePagingViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/26.
//

import Foundation
import UIKit
import Parchment

class CarPricePagingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let pagingViewController = PagingViewController()
        pagingViewController.register(CarPricePagingCell.self, for: CarPricePagingItem.self)
        
        pagingViewController.menuItemSize = .fixed(width: 40, height: 40)
        pagingViewController.menuItemSpacing = 10
        pagingViewController.menuBackgroundColor = .clear
        
        pagingViewController.infiniteDataSource = self
        pagingViewController.select(pagingItem: CarPricePagingItem(pageNumber: 1))
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension CarPricePagingViewController: PagingViewControllerInfiniteDataSource {
    func pagingViewController(_: PagingViewController, itemAfter pagingItem: PagingItem) -> PagingItem? {
        let carPricePagingItem = pagingItem as! CarPricePagingItem
        return CarPricePagingItem(pageNumber: carPricePagingItem.pageNumber + 1)
    }
    
    func pagingViewController(_: PagingViewController, itemBefore pagingItem: PagingItem) -> PagingItem? {
        let carPricePagingItem = pagingItem as! CarPricePagingItem
        if carPricePagingItem.pageNumber <= 1 {
            return nil
        } else {
            return CarPricePagingItem(pageNumber: carPricePagingItem.pageNumber - 1)
        }
    }
    
    func pagingViewController(_: PagingViewController, viewControllerFor pagingItem: PagingItem) ->   UIViewController {
        let carPricePagingItem = pagingItem as! CarPricePagingItem
        return CarPriceCollectionViewController(pageNumber: carPricePagingItem.pageNumber)
    }
}

