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
    
    let stackViewCell = StackViewCollectionViewCell()
    
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
        view.addSubview(stackViewCell)
        view.addSubview(collectionView)
        
        stackViewCell.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackViewCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: stackViewCell.bottomAnchor, constant: 8),
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
        
        doubleTitleView.leftButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        doubleTitleView.rightButton.titleLabel?.font = .systemFont(ofSize: 30)
    }
    
    @objc func rightButtonTapped() {
        tab = .grave
        
        collectionView.reloadData()
        
        doubleTitleView.leftButton.titleLabel?.font = .systemFont(ofSize: 30)
        doubleTitleView.rightButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
    }
    
    @objc func plusButtonTapped() {
        let vc = ModalViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.automatic

            self.present(vc, animated: true, completion: nil)
    }
}
