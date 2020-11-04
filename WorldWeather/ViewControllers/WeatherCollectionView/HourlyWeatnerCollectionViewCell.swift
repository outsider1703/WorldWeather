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
    
    let weatherImage = UIImageView()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
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
        tempLabel.text = "\(Int(hourl.temp))°C"
    }
    
    private func setupViews() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
        }
        addSubview(weatherImage)
        weatherImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 65, height: 65))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}
