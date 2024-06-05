//
//  BookmarkTableViewController.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit

class BookmarkTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
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
        view.addSubview(customSearchBar)
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            customSearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            customSearchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            customSearchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            customSearchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        customSearchBar.infoButton.addAction(UIAction(){[weak self] _ in
            guard let self = self else { return }
            let searchInfoViewController = SearchInfoViewController()
            searchInfoViewController.modalPresentationStyle = .popover
            
            if let popoverController = searchInfoViewController.popoverPresentationController {
                popoverController.sourceView = self.customSearchBar.infoButton
                popoverController.sourceRect = self.customSearchBar.infoButton.bounds
                popoverController.permittedArrowDirections = .any
                popoverController.delegate = self
            }
            
            self.present(searchInfoViewController, animated: true, completion: nil)
        }, for: .touchUpInside)
        search.setValue(customSearchBar, forKey: "searchBar")
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "계정 및 해시태그 검색"
        search.searchBar.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let customSearchBar = searchBar as? CustomSearchBar {
            if searchText.isEmpty {
                customSearchBar.infoButton.isHidden = false
            } else {
                customSearchBar.infoButton.isHidden = true
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
        self.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            infoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            infoButton.widthAnchor.constraint(equalToConstant: 26),
            infoButton.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}

class SearchInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "검색 \n관련 \n설명"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
        ])
        
        self.preferredContentSize = CGSize(width: 200, height: 200)
    }
}

