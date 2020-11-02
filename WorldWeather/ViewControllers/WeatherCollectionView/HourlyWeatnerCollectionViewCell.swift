//
//  HourlyWeatnerCollectionViewCell.swift
//  WorldWeather
//
//  Created by Macbook on 21.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class TodayHourlyWeatnerCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "TodayCell"
    
    let timeLabel = UILabel()
    let weatherImage = UIImageView()
    let tempLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
        contentView.layer.cornerRadius = 8
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with hourl: CustomHourl) {
        timeLabel.text = "\(hourl.date)"
        weatherImage.image = UIImage(named: hourl.icon)
        tempLabel.text = "\(hourl.temp)°C"
        descriptionLabel.text = hourl.description
    }
    
    private func setupViews() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
//            make.top.equalTo(contentView).offset(0)
//            make.leading.equalTo(contentView).offset(8)
//            make.trailing.equalTo(contentView).offset(-8)
        }
        addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.size.equalTo(CGSize(width: 25, height: 50))
//                        make.leading.equalTo(contentView).offset(8)
//                        make.trailing.equalTo(contentView).offset(-8)
//
            make.centerX.equalToSuperview()
        }
        addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(2)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            // make.bottom.equalTo(descriptionLabel.snp.top).offset(2)
        }
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.bottom.equalTo(contentView).offset(0)
        }
    }
}
