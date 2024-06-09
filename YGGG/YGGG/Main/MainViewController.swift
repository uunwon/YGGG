//
//  MainViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/4/24.
//

import UIKit

enum Tab {
    case home, grave
}

class MainViewController: UIViewController {
    var tab = Tab.home
    let cellHeight: CGFloat = 150
    
    lazy var stackView: UIStackView = {
        let titles = ["전체", "냉동", "냉장", "실온"]
        
        let buttons = titles.compactMap {
            let button = UIButton()
            button.setTitle($0, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            return button
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let doubleTitleView = DoubleTitleView()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: cellHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.name)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        doubleTitleView.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        doubleTitleView.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: doubleTitleView.leftButton),
            UIBarButtonItem(customView: doubleTitleView.rightButton)
        ]
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
        
    }
    
    func setupCollectionView() {
        view.addSubview(stackView)
        view.addSubview(collectionView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.name, for: indexPath) as! CustomCollectionViewCell
        
        switch tab {
        case .home:
            cell.configureHome()
        case .grave:
            cell.configureGrave()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension MainViewController {
    @objc func leftButtonTapped() {
        tab = .home
        
        collectionView.reloadData()
        
        doubleTitleView.leftButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        doubleTitleView.rightButton.titleLabel?.font = .systemFont(ofSize: 25)
        doubleTitleView.rightButton.setTitleColor(.gray, for: .normal)
        doubleTitleView.leftButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func rightButtonTapped() {
        tab = .grave
        
        collectionView.reloadData()
        
        doubleTitleView.leftButton.titleLabel?.font = .systemFont(ofSize: 25)
        doubleTitleView.rightButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        doubleTitleView.leftButton.setTitleColor(.gray, for: .normal)
        doubleTitleView.rightButton.setTitleColor(.black, for: .normal)
    }
    
    @objc func plusButtonTapped() {
        let vc = NameModalViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = .automatic
        self.present(nav, animated: true, completion: nil)
        
        
    }
    
}
