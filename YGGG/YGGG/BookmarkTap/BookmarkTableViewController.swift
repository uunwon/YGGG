//
//  BookmarkTableViewController.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
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
    
    var datas: [User] = []
    var bookmarkList: [String] = []
    
    //task: 로그인된 계정의 id 가져오기
    var myID = "67p8Fleq5wgDNnkEG2yB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupCustomSearchBar()
        setupTableView()
        setupTapGesture()
        setupObserver()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
//            await loadActiveUserID()
            await loadBookmarkList()
        }
    }
    
    private func loadActiveUserID() async {
        let user = Auth.auth().currentUser
        if let user = user {
            myID = user.uid
        }
    }
    
    private func loadBookmarkList() async {
        do {
            let db = Firestore.firestore()
            let activeUserDocRef = db.collection("users").document(myID)
            let activeUserData = try await activeUserDocRef.getDocument(as: User.self)
            
            bookmarkList = activeUserData.bookmarkList
            
            var loadedDatas: [User] = []
            let snapshot = try await db.collection("users").whereField("uid", in: bookmarkList).getDocuments()
            for document in snapshot.documents {
                if let data = try? document.data(as: User.self) {
                    loadedDatas.append(data)
                }
            }
            
            self.datas = loadedDatas
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    private func loadFilteredList(searchText: String) async {
        do {
            let db = Firestore.firestore()
            let snapshotByName = try await db.collection("users")
                .whereField("userName", isGreaterThanOrEqualTo: searchText)
                .whereField("userName", isLessThanOrEqualTo: searchText + "\u{f7ff}")
                .getDocuments()
            
            var loadedDatas: [User] = []
            for document in snapshotByName.documents {
                if let data = try? document.data(as: User.self) {
                    loadedDatas.append(data)
                }
            }
            
            self.datas = loadedDatas
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error getting documents: \(error)")
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
    
    @objc func dismissKeyboard() {
        customSearchBar.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            view.frame.size.height -= keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            view.frame.size.height += keyboardHeight
        }
    }
}

extension BookmarkTableViewController: UITableViewDataSource, UITableViewDelegate, BookmarkTableViewControllerDelegate, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarkTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        let userEntry = datas[indexPath.row]
        cell.configureCell(user: userEntry, bookmarkList: bookmarkList)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        87
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //이동
        print("이동")
    }
    
    func toggleBookmark(uid: String, completion: @escaping (Bool) -> Void) async {
        do {
            let isBookmarked: Bool
            if bookmarkList.contains(uid) {
                bookmarkList = bookmarkList.filter { $0 != uid }
                isBookmarked = false
            } else {
                bookmarkList.append(uid)
                isBookmarked = true
            }
            
            let db = Firestore.firestore()
            let activeUserDocRef = db.collection("users").document(myID)
            try await activeUserDocRef.updateData(["bookmarkList" : bookmarkList])
            
            completion(isBookmarked)
        } catch {
            print("Error toggling documents: \(error)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let customSearchBar = searchBar as? CustomSearchBar {
            if searchText.isEmpty {
                customSearchBar.infoButton.isHidden = false
                Task {
                    await loadBookmarkList()
                }
            } else {
                customSearchBar.infoButton.isHidden = true
                Task {
                    await loadFilteredList(searchText: searchText)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

