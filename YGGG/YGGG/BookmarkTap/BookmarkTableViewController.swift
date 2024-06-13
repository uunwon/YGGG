//
//  ControllerBookmarkTableView.swift
//  YGGG
//
//  Created by 김영훈 on 6/11/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BookmarkTableViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        return search
    }()
    
    private lazy var customSearchBar: CustomSearchBar = {
        let customSearchBar = CustomSearchBar()
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        return customSearchBar
    }()
    
    private lazy var listEmptyLabel: UILabel = {
       let listEmptyLabel = UILabel()
        listEmptyLabel.numberOfLines = 10
        listEmptyLabel.textAlignment = .center
        listEmptyLabel.isHidden = true
        listEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        return listEmptyLabel
    }()
    
    private let bookmarkTableViewModel = BookmarkTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupCustomSearchBar()
        setupTableView()
        setupTapGesture()
        setupObserver()
        setupListEmptyView()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        Task {
            if let searchText = customSearchBar.text, searchText.isEmpty {
                await bookmarkTableViewModel.loadBookmarkList()
                if bookmarkTableViewModel.datas.isEmpty, let showEmptyBookmarkText = bookmarkTableViewModel.showEmptyBookmarkText {
                    showEmptyBookmarkText()
                }
            } else {
                await bookmarkTableViewModel.loadFilteredList(searchText: customSearchBar.text!)
            }
        }
    }
    
    private func setupCustomSearchBar() {
        view.addSubview(customSearchBar)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            customSearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            customSearchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            customSearchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
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
        search.searchBar.placeholder = "계정 이름으로 검색"
        search.searchBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "bookmarkCell")
        view.addSubview(tableView)
        
        bookmarkTableViewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        bookmarkTableViewModel.showEmptyBookmarkText = { [weak self] in
            self?.listEmptyLabel.text = "북마크 목록이 비었습니다.\n\n이름으로 검색하여 북마크 목록을 추가하세요."
            self?.listEmptyLabel.isHidden = false
        }
        bookmarkTableViewModel.hideListEmptyLabel = { [weak self] in
            self?.listEmptyLabel.isHidden = true
        }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupListEmptyView() {
        view.addSubview(listEmptyLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            listEmptyLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            listEmptyLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            listEmptyLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            listEmptyLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    @objc func dismissKeyboard() {
        customSearchBar.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}

extension BookmarkTableViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarkTableViewModel.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self.bookmarkTableViewModel
        let userEntry = bookmarkTableViewModel.datas[indexPath.row]
        cell.bookmarkCellViewModel = BookmarkTableViewCellViewModel(user: userEntry, bookmarkList: bookmarkTableViewModel.bookmarkList)
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        87
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = bookmarkTableViewModel.datas[indexPath.row]
        let viewMoel = ProfileViewModel(user: user)
        let vc = ProfileViewController(viewModel: viewMoel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let customSearchBar = searchBar as? CustomSearchBar {
            if searchText.isEmpty {
                customSearchBar.infoButton.isHidden = false
                Task {
                    await bookmarkTableViewModel.loadBookmarkList()
                }
            } else {
                customSearchBar.infoButton.isHidden = true
                Task {
                    await bookmarkTableViewModel.loadFilteredList(searchText: searchText)
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let hideListEmptyLabel = bookmarkTableViewModel.hideListEmptyLabel {
            hideListEmptyLabel()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !self.search.isActive, let showEmptyBookmarkText = bookmarkTableViewModel.showEmptyBookmarkText, let searchText = searchBar.text, searchText.isEmpty, bookmarkTableViewModel.datas.isEmpty {
            showEmptyBookmarkText()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
