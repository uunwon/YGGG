//
//  BookmarkTableViewController.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit

class BookmarkTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    lazy var infoButton: UIButton = {
        let infoButton = UIButton()
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        return infoButton
    }()
    
    var datas = UserInfoEntry.sampleDatas
    let search = UISearchController(searchResultsController: nil)
    let customSearchBar = CustomSearchBar()
    var filteredTableData: [UserInfoEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "bookmarkCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        search.setValue(customSearchBar, forKey: "searchBar")
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "계정 및 해시태그 검색"
        search.searchBar.delegate = self
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkTableViewCell
        cell.selectionStyle = .none
        let userInfoEntry = datas[indexPath.row]
        cell.configureCell(userInfoEntry: userInfoEntry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        87
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        
        
        filteredTableData = datas.filter {
            $0.name.lowercased().contains(searchBarText.lowercased())
        }

        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let customSearchBar = searchBar as? CustomSearchBar {
            if searchText.isEmpty {
                customSearchBar.infoButton.isHidden = false
            } else {
                customSearchBar.infoButton.isHidden = true
            }
        }
    }
    
    
    
    class CustomSearchBar: UISearchBar {
        
        var infoButton: UIButton = {
            let infoButton = UIButton(type: .infoLight)
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
            return infoButton
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupInfoButton()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupInfoButton() {
            infoButton.translatesAutoresizingMaskIntoConstraints = false
            infoButton.addAction(UIAction(){_ in print("infobutton")}, for: .touchUpInside)
            self.addSubview(infoButton)
            
            NSLayoutConstraint.activate([
                infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                infoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                infoButton.widthAnchor.constraint(equalToConstant: 26),
                infoButton.heightAnchor.constraint(equalToConstant: 26)
            ])
        }
    }
}
