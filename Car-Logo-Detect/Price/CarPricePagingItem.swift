//
//  CarPricePagingItem.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/3/26.
//

import Foundation
import Parchment

struct CarPricePagingItem: PagingItem, Hashable, Comparable {
    let pageNumber: Int
  
    static func < (lhs: CarPricePagingItem, rhs: CarPricePagingItem) -> Bool {
        return lhs.pageNumber < rhs.pageNumber
    }
}
