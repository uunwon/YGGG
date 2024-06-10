//
//  ProfileViewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/5/24.
//

import UIKit


class ProfileViewController: UIViewController {
    
    private var viewModel = ProfileViewModel()
    
    var categorySelectedIndex: IndexPath?
    private let mainProfileView = ProfileMainView()
    
    private lazy var categoryCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 83, height: 39)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 19, bottom: 15, right: 19)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.register(CategoryCVCell.self, forCellWithReuseIdentifier: "CategoryCVCell")
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var cosmeticsTV: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 148
        tv.register(CosmeticsTVCell.self, forCellReuseIdentifier: "CosmeticsTVCell")
        tv.separatorStyle = .none
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureUI()
//        configureDataSetup()
        
        
        categorySelectedIndex = IndexPath(row: 0, section: 0)
        categoryCV.selectItem(at: categorySelectedIndex, animated: false, scrollPosition: .left)
        
        viewModel.loadData {
            self.configureUI()
            self.configureDataSetup()
        }
//        ProfileService.shared.getData(completion: <#T##(User) -> Void#>)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
//        view.addSubview(mainProfileView)
        mainProfileView.translatesAutoresizingMaskIntoConstraints = false
        [mainProfileView, categoryCV, cosmeticsTV].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            mainProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainProfileView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
//        view.addSubview(profileView)
        
        navigationController?.navigationBar.backgroundColor = .blue
        
        //categoryCV Constraint Setting
        NSLayoutConstraint.activate([
            categoryCV.topAnchor.constraint(equalTo: mainProfileView.bottomAnchor),
            categoryCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCV.heightAnchor.constraint(equalToConstant: 69)
        ])
        
        //cosmeticsTV Constraint Setting
        NSLayoutConstraint.activate([
            cosmeticsTV.topAnchor.constraint(equalTo: categoryCV.bottomAnchor),
            cosmeticsTV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cosmeticsTV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cosmeticsTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        
    }
    
    private func configureDataSetup() {
        mainProfileView.setupUI(userImage: "",
                                userName: viewModel.getUserName(), tombCount: viewModel.getUserTombCount(),
                                refrigeratorCount: viewModel.getUserRefrigeratorCount(), hashTag: viewModel.getUserHashTag())

        favoriteButtonSetup()
    }
    
    private func favoriteButtonSetup() {
//        let favoriteImage = viewModel.userIsFavorite() ? "bookMark.fill" : "bookMark"
//        favoriteButton.setImage(UIImage(named: favoriteImage), for: .normal)
    }
    
    @objc private func favoriteTapped() {
//        viewModel.changeFavorite { [weak self] in
//            self?.favoriteButtonSetup()
//        }
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topCateogoryCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVCell", for: indexPath) as? CategoryCVCell {
            
            let category = viewModel.getCategoryItem(index: indexPath.row)
            cell.configureCell(category: category)
            cell.isSelected = (indexPath == categorySelectedIndex)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getSectionCosmetic(caseType: indexPath.row) {
            self.cosmeticsTV.reloadData()
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cosmeticsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CosmeticsTVCell", for: indexPath) as? CosmeticsTVCell {
            
            let cosmetic = viewModel.getCosmetic(index: indexPath.row)
            cell.configureCell(cosmetic: cosmetic)
            
            return cell
        }
        return UITableViewCell()
    }
}
