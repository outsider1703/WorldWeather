//
//  MainSearchViewController.swift
//  WorldWeather
//
//  Created by Macbook on 20.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class MainSearchViewController: UIViewController {
    
    private let cities = CityDictionary.cityDictionary
    private var filteredCities = [String]()
    private var recentRequests = [String]()
    
    private let citySearchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barTintColor = .background
        searchBar.tintColor = .white
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView = nil
        searchBar.searchTextField.clearButtonMode = .never
        return searchBar
    }()
    private let resultsTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .background
        table.separatorColor = .background
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setUpViews()
        citySearchBar.delegate = self
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        settingNavigation()
        checkRecentRequests()
    }
    
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard filteredCities.count > 0 else { return }
        recentRequests.append(filteredCities[indexPath.item])
        let cityWeatherVC = CityWeatherViewController()
        cityWeatherVC.setCustomDataFor(city: cities[filteredCities[indexPath.item]] ?? "")
        cityWeatherVC.transferCity(name: filteredCities[indexPath.item])
        cityWeatherVC.navigationItem.backButtonTitle = "  "
        cityWeatherVC.navigationItem.largeTitleDisplayMode = .never
        cityWeatherVC.navigationItem.title = "Погода в городе"
        navigationController?.pushViewController(cityWeatherVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = 0
        if filteredCities.count > 0 {
            rowsCount = filteredCities.count
        } else {
            rowsCount = recentRequests.count
        }
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.selectedBackgroundView?.tintColor = .red
        cell.selectedBackgroundView?.backgroundColor = .red
        cell.backgroundColor = .background
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        if filteredCities.count > 0 {
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = filteredCities[indexPath.item]
        } else {
            cell.textLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.16)
            cell.textLabel?.text = recentRequests[indexPath.item]
        }
        return cell
    }
}
//MARK: - UISearchBarDelegate
extension MainSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = cities.keys.filter({ $0.contains(searchText) })
        if !searchText.isEmpty && filteredCities.count > 0 {
            setHeaderView(label: "Похожие запросы")
        }
        if searchText.isEmpty {
            checkRecentRequests()
        }
        resultsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        setHeaderView(label: nil)
        resultsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCities = []
        checkRecentRequests()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        resultsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
//MARK: - Private Function
extension MainSearchViewController {
    
    private func checkRecentRequests() {
        if recentRequests.count > 0 {
            setHeaderView(label: "Последние запросы")
        }
    }
    
    private func setHeaderView(label text: String?) {
        if text != nil {
            let customHeader = UIView()
            customHeader.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 18)
            customHeader.backgroundColor = .background
            let headerLabel = UILabel()
            headerLabel.frame = CGRect(x: 16, y: 8, width: view.frame.width, height: 18)
            headerLabel.text = text
            headerLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.56)
            customHeader.addSubview(headerLabel)
            resultsTableView.tableHeaderView = customHeader
        } else {
            resultsTableView.tableHeaderView = nil
        }
    }
    
    private func settingNavigation() {
        navigationItem.title = "Погода"
        navigationItem.backButtonTitle = " "
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                .font: UIFont.boldSystemFont(ofSize: 20)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .background
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        let image = UIImage(systemName: "questionmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let barButton = UIBarButtonItem(image: image,
                                        style: .done,
                                        target: self,
                                        action: #selector(showHintAlert))
        barButton.tintColor = .white
        navigationItem.rightBarButtonItem = barButton
    }
    @objc func showHintAlert() {
        showHint(
            title: "Города в которых можно посмотреть достопримечательности",
            massage: "Калининград, Сан-франциско, Томск, Токио, Лондон")
    }
    
    private func setUpViews() {
        view.addSubview(citySearchBar)
        citySearchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        view.addSubview(resultsTableView)
        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(citySearchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    private func showHint(title: String, massage: String?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
