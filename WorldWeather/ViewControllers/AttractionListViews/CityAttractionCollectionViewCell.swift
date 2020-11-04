//
//  CityAttractionCollectionViewCell.swift
//  WorldWeather
//
//  Created by Macbook on 25.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class CityAttractionCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "AttractionCell"
    
    private let gradientView = UIView()
    private let nameAttractionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Name Attraction"
        return label
    }()
    private let descriptionAttractionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        label.numberOfLines = 4
        label.text = "Descriptionfor Attraction"
        return label
    }()
    private let attractionImage: ImageView = {
        let image = ImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.image = UIImage(named: "NotImage")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradientLayer()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingDescriptionFor(attraction: Attraction?) {
        guard let attraction = attraction else { return }
        attractionImage.fetchImage(from: attraction.image ?? "")
        nameAttractionLabel.text = attraction.name
        descriptionAttractionLabel.text = attraction.desc
    }
    
    private func setupView() {
        contentView.addSubview(attractionImage)
        attractionImage.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        contentView.addSubview(descriptionAttractionLabel)
        descriptionAttractionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        contentView.addSubview(nameAttractionLabel)
        nameAttractionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionAttractionLabel.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    private func addGradientLayer() {
        let transparentColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [transparentColor.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 0.6)
        gradient.cornerRadius = 12
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
