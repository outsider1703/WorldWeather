//
//  CityWeatherViewController.swift
//  WorldWeather
//
//  Created by Macbook on 21.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import MapKit

class CityWeatherViewController: UIViewController {
    
    let cityNameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "City Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nameLabel.textColor = .white
        return nameLabel
    }()
    private let cityOnMap: MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    private let attractionsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        button.setTitle("Достопримечательности", for: .normal)
        button.addTarget(self, action: #selector(pushToCityAttraction), for: .touchUpInside)
        return button
    }()
    
    private var weatherCollection: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<CustomDataModelForWeather, CustomHourl>?
    
    private var citiesOfPresence = [City]()
    private var cityAttractions: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setCustomData()
        
        setUpViews()
        
        setupCollectionView()
        
        createDataSource()
                
        citiesOfPresence.append(CityGetter.firstCity)
        checkCitiesOfPresence()
    }
    
    @objc func pushToCityAttraction() {
        let cityAttractionListVC = CityAttractionsListViewController()
        cityAttractionListVC.navigationItem.title = "Достопримечательности"
        cityAttractionListVC.navigationItem.backButtonTitle = " "
        cityAttractionListVC.cityAttractions = cityAttractions
        navigationController?.pushViewController(cityAttractionListVC, animated: true)
    }
    
}
//MARK: - Private Function
extension CityWeatherViewController {
    private func checkCitiesOfPresence() {
        for city in citiesOfPresence {
            if city.name == "Калининград" {
                cityAttractions = city
            } else {
                attractionsButton.isHidden = true
            }
        }
    }
    
    private func setCustomData() {
        NetworkManager.shared.fetchCoordinatesFor(city: "Tokio") { (weatherData) in
            let customazer = DataCustomizerManager()
            let customWeather = customazer.customizingForWeather(data: weatherData)
            self.reloadDataFor(customData: customWeather)
            DispatchQueue.main.async {
                let lat = customWeather.first?.lat ?? 0
                let lon = customWeather.first?.lon ?? 0
                self.setLocationForCoord(lat: lat, lon: lon)
            }
        }
    }
    
    private func setLocationForCoord(lat: Double, lon: Double) {
        let initialLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        cityOnMap.centerLocation(initialLocation)
        
        let marker = MKPointAnnotation()
        marker.coordinate = initialLocation
        cityOnMap.addAnnotation(marker)
    }
    
    private func setUpViews() {
        view.addSubview(cityOnMap)
        cityOnMap.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: 144))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
        }
        view.addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cityOnMap.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        view.addSubview(attractionsButton)
        attractionsButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width - 32, height: 56))
            make.leading.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-80)
        }
    }
}
//MARK: - Setup Weather Collection View
extension CityWeatherViewController {
    private func setupCollectionView() {
        weatherCollection = UICollectionView(frame: CGRect(x: 0, y: 300, width: view.frame.width, height: 400),
                                             collectionViewLayout: createCompositionalLayout())
        
        weatherCollection.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollection.backgroundColor = .background
        
        weatherCollection.register(TodayHourlyWeatnerCollectionViewCell.self,
                                   forCellWithReuseIdentifier: TodayHourlyWeatnerCollectionViewCell.reuseId)
        weatherCollection.register(SectionHeader.self,
                                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                   withReuseIdentifier: SectionHeader.reuserId)
        view.addSubview(weatherCollection!)
    }
    
    //MARK: - DataSource
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CustomDataModelForWeather, CustomHourl>(collectionView: weatherCollection, cellProvider: { (collectionView, indexPath, hourl) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayHourlyWeatnerCollectionViewCell.reuseId, for: indexPath) as? TodayHourlyWeatnerCollectionViewCell
            cell?.configure(with: hourl)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuserId, for: indexPath) as? SectionHeader else { return nil }
            guard let firstChat = self.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: firstChat) else { return nil }
            if section.day.isEmpty { return nil }
            
            sectionHeader.title.text = section.day
            return sectionHeader
        }
    }
    
    private func reloadDataFor(customData: [CustomDataModelForWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<CustomDataModelForWeather, CustomHourl>()
        snapshot.appendSections(customData)
        for section in customData {
            snapshot.appendItems(section.hourlyData, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    //MARK: - UICollectionViewLayout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createWaitingChatSection()
        }
        return layout
    }
    
    private func createWaitingChatSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(120))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 12, leading: 12, bottom: 0, trailing: 12)
        
        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]
        
        return layoutSection
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHEaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .estimated(1))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHEaderSize,
                                                                              elementKind: UICollectionView.elementKindSectionHeader,
                                                                              alignment: .top)
        return layoutSectionHeader
    }
}
