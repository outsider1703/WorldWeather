//
//  SectionHeader.swift
//  WorldWeather
//
//  Created by Macbook on 24.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let reuserId = "SectionHeader"
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
        label.font = UIFont(name: "avenir", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
