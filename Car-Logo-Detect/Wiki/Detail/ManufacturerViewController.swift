//
//  ManufacturerViewController.swift
//  Car-Logo-Detect
//
//  Created by swp on 2025/1/21.
//

import Foundation
import UIKit
import Eureka
import SnapKit

class ManufacturerViewController: FormViewController {
    private var resultItem: ManufacturerResult
    
    init(item: ManufacturerResult) {
        resultItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(){ section in
            section.header = {
                var header = HeaderFooterView<UILabel>(.callback({
                    let title = UILabel()
                    title.text = self.resultItem.Mfr_Name
                    title.textAlignment = .center
                    title.font = UIFont.boldSystemFont(ofSize: 24)
                    title.backgroundColor = .clear
                    title.numberOfLines = 0 // Allow multi line display
                    title.lineBreakMode = .byWordWrapping // Wrap by word
                    return title
                }))
                header.height = { 150 }
                return header
            }()
        }
            <<< LabelRow(){ row in
                row.title = "Country"
                row.value = resultItem.Country
            }
            <<< LabelRow(){ row in
                row.title = "Province"
                row.value = resultItem.StateProvince
            }
            <<< LabelRow(){ row in
                row.title = "City"
                row.value = resultItem.City
            }
            <<< LabelRow(){ row in
                row.title = "Address"
                row.value = resultItem.Address
            }
            <<< LabelRow(){ row in
                row.title = "Postal code"
                row.value = resultItem.PostalCode
            }
            <<< LabelRow(){ row in
                row.title = "Phone"
                row.value = resultItem.ContactPhone
            }
            <<< LabelRow(){ row in
                row.title = "Email"
                row.value = resultItem.ContactEmail
            }
    }
}
