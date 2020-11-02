//
//  InformationAttractionViewController.swift
//  WorldWeather
//
//  Created by Macbook on 27.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import MapKit

class InformationAttractionViewController: UIViewController {
    
    var descriptionForAttraction: CityAttractionsModel!
    
    private let attractionImage: ImageView = {
        let image = ImageView()
        return image
    }()
    private let nameAttractionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.text = "Name Attraction"
        return label
    }()
    private let descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = .white
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.text = "Описание"
        return label
    }()
    private let fullDescriptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Читать дальше", for: .normal)
        button.titleLabel?.textColor = UIColor.blue
        button.addTarget(self, action: #selector(readMoreVC), for: .touchUpInside)
        return button
    }()
    private let mapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "На карте"
        return label
    }()
    private let attractionOnMap: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupView()
        settingDescriptionForAttraction()
        setLocationForMap()
    }
    
    @objc func readMoreVC() {
        let fullTextVC = FullTextViewController()
        fullTextVC.fullTextView.text = descriptionForAttraction.descfull
        present(fullTextVC, animated: true)
    }
}
//MARK: - Private Function
extension InformationAttractionViewController {
    
    private func setLocationForMap() {
        let initialLocation = CLLocationCoordinate2D(latitude: descriptionForAttraction.geoCoord.lan,
                                                    longitude: descriptionForAttraction.geoCoord.lon)
        attractionOnMap.centerLocation(initialLocation, regionRadius: 1000)
        
        let marker = MKPointAnnotation()
        marker.coordinate = initialLocation
        attractionOnMap.addAnnotation(marker)
    }
    
    private func settingDescriptionForAttraction() {
        attractionImage.fetchImage(from: descriptionForAttraction.image)
        nameAttractionLabel.text = descriptionForAttraction.name
        descriptionTextLabel.text = descriptionForAttraction.descfull
    }
    
    private func setupView() {
        view.addSubview(attractionImage)
        attractionImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: view.frame.height / 4))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        view.addSubview(nameAttractionLabel)
        nameAttractionLabel.snp.makeConstraints { make in
            make.top.equalTo(attractionImage.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        view.addSubview(descriptionTextLabel)
        descriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAttractionLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        view.addSubview(fullDescriptionButton)
        fullDescriptionButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(24)
        }
        view.addSubview(attractionOnMap)
        attractionOnMap.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: 214))
            make.bottom.equalToSuperview()
        }
        view.addSubview(mapLabel)
        mapLabel.snp.makeConstraints { make in
            make.bottom.equalTo(attractionOnMap.snp.top).offset(-16)
            make.leading.equalToSuperview().offset(24)
        }
    }
}
