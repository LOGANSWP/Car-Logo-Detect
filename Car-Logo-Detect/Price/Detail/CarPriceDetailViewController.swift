//
//  CarPriceDetailViewController.swift
//  Car-Logo-Detect
//
//  Created by LoganSu on 2025/2/6.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa
import Eureka

class CarPriceDetailViewController: FormViewController {
    private var priceItem: PriceResult
    
    init(item: PriceResult) {
        priceItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(){ section in
            section.header = {
                var header = HeaderFooterView<UILabel>(.callback({
                    let title = UILabel()
                    title.backgroundColor = .clear
                    return title
                }))
                header.height = { 30 }
                return header
            }()
        }
        
        form +++ Section(){ [weak self] section in
            section.header = {
                var header = HeaderFooterView<UIImageView>(.callback({
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFit
                    imageView.clipsToBounds = true
                    
                    guard let stringURL = self?.priceItem.primaryPhotoUrl,
                          let imageURL = URL(string: stringURL) else {
                        print("Invalid image URL")
                        return imageView
                    }

                    imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [.retryFailed, .refreshCached]) { (image, error, _, _) in
                        if let error = error {
                            print("Image loading error: \(error.localizedDescription)")
                        }
                    }
                    
                    return imageView
                }))
                header.height = { 300 }
                return header
            }()
        }
        
        form +++ Section(){ section in
            section.header = {
                var header = HeaderFooterView<UILabel>(.callback({
                    let title = UILabel()
                    title.backgroundColor = .clear
                    return title
                }))
                header.height = { 10 }
                return header
            }()
        }

        <<< LabelRow(){ row in
            row.title = "Make"
            row.value = priceItem.make
        }
        <<< LabelRow(){ row in
            row.title = "Model"
            row.value = priceItem.model
        }
        <<< LabelRow(){ row in
            row.title = "Price"
            row.value = priceItem.price
        }
        <<< LabelRow(){ row in
            row.title = "Mile Age"
            row.value = priceItem.mileage
        }
        <<< LabelRow(){ row in
            row.title = "Display Color"
            row.value = priceItem.displayColor
        }
        <<< LabelRow(){ row in
            row.title = "State"
            row.value = priceItem.state
        }
        <<< LabelRow(){ row in
            row.title = "City"
            row.value = priceItem.city
        }
        <<< LabelRow(){ row in
            row.title = "Lat"
            row.value = "\(priceItem.lat ?? 0)"
        }
        <<< LabelRow(){ row in
            row.title = "Lon"
            row.value = "\(priceItem.lon ?? 0)"
        }
        <<< LabelRow(){ row in
            row.title = "Condition"
            row.value = priceItem.condition
        }
        <<< LabelRow(){ row in
            row.title = "Created Time"
            row.value = priceItem.createdAt
        }
        <<< LabelRow(){ row in
            row.title = "Updated Time"
            row.value = priceItem.updatedAt
        }
        <<< LabelRow(){ row in
            row.title = "Dealer"
            row.value = priceItem.dealerName
        }
        <<< LabelRow(){ row in
            row.title = "Trim"
            row.value = priceItem.trim
        }
        <<< LabelRow(){ row in
            row.title = "Body Type"
            row.value = priceItem.bodyType
        }
        <<< LabelRow(){ row in
            row.title = "Body Style"
            row.value = priceItem.bodyStyle
        }
        <<< ButtonRow() { row in
            row.title = "Click to View in Browser"
        }.onCellSelection { [weak self] cell, row in
            guard let self,
                  var urlString = self.priceItem.clickoffUrl else {
                return
            }

            // Check whether the prefix contains http or https
            if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                urlString = "https://" + urlString
            }

            guard let url = URL(string: urlString),
                  UIApplication.shared.canOpenURL(url) else {
                print("Invalid URL")
                return
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        <<< ButtonRow() { row in
            row.title = "Click to ask AI car consultant"
        }.onCellSelection { [weak self] cell, row in
            guard let self else { return }
            present(AIAssistantViewController(priceResult: priceItem), animated: true)
        }
    }
}
