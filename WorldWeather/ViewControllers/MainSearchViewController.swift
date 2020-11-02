//
//  MainSearchViewController.swift
//  WorldWeather
//
//  Created by Macbook on 20.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class MainSearchViewController: UIViewController {
        
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
    
    private let cities = ["Калининград", "Дубай", "Сан-франциско", "Томск", "Токио"]
    private var filteredCities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setUpViews()
        citySearchBar.delegate = self
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        settingNavigation()
    }
    
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension MainSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityWeatherVC = CityWeatherViewController()
        cityWeatherVC.navigationItem.backButtonTitle = " "
        cityWeatherVC.navigationItem.largeTitleDisplayMode = .never
        cityWeatherVC.navigationItem.title = "Погода в городе"
        cityWeatherVC.cityNameLabel.text = filteredCities[indexPath.row]
        navigationController?.pushViewController(cityWeatherVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.selectedBackgroundView?.tintColor = .red
        cell.selectedBackgroundView?.backgroundColor = .red
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .background
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        cell.textLabel?.text = filteredCities[indexPath.row]
        return cell
    }
}
//MARK: - UISearchBarDelegate
extension MainSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        setHeaderView(label: "Похожие запросы")
        filteredCities = cities.filter({ $0.contains(searchText) })
        resultsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        setHeaderView(label: nil)
        resultsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setHeaderView(label: nil)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredCities = []
        resultsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
//MARK: - Private Function
extension MainSearchViewController {
    
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
    }
    
    private func setUpViews() {
        view.addSubview(citySearchBar)
        citySearchBar.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: view.frame.width, height: 100))
            make.leading.equalTo(view).offset(0)
            make.trailing.equalTo(view).offset(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
        }
        view.addSubview(resultsTableView)
        resultsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(citySearchBar.snp.bottom).offset(0)
            make.leading.equalTo(view).offset(0)
            make.trailing.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }
}
