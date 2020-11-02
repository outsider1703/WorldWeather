//
//  CityAttractionViewController.swift
//  WorldWeather
//
//  Created by Macbook on 25.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class CityAttractionsListViewController: UIViewController {
    
    var cityAttractions: City!
    
    private var cityAttractionCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        cityAttractionCollectionView.delegate = self
        cityAttractionCollectionView.dataSource = self
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 32, height: view.frame.height / 3)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cityAttractionCollectionView = UICollectionView(frame: view.bounds,
                                                        collectionViewLayout: layout)
        cityAttractionCollectionView.backgroundColor = .background
        cityAttractionCollectionView.register(CityAttractionCollectionViewCell.self,
                                              forCellWithReuseIdentifier: CityAttractionCollectionViewCell.reuseId)
        view.addSubview(cityAttractionCollectionView)
    }
}

extension CityAttractionsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let informationAttractionVC = InformationAttractionViewController()
        informationAttractionVC.navigationItem.title = cityAttractions.attractions[indexPath.row].name
        informationAttractionVC.descriptionForAttraction = cityAttractions.attractions[indexPath.row]
        self.navigationController?.pushViewController(informationAttractionVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityAttractions.attractions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityAttractionCollectionViewCell.reuseId, for: indexPath) as! CityAttractionCollectionViewCell
        cell.settingDescriptionFor(attraction: cityAttractions.attractions[indexPath.row])
        return cell
    }
}
