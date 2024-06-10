//
//  IconModalViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/8/24.
//

import UIKit

class IconModalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var selectedCellIndex: IndexPath?

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .setlightgreen
        view.layer.cornerRadius = 50
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_modal"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "모양 선택"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("추가", for: .normal)
        button.backgroundColor = .setorange
        button.tintColor = .black
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CircleButtonCell.self, forCellWithReuseIdentifier: "CircleButtonCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(buttonNext)
        
        buttonNext.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 이미지 선택 알림을 수신하고 imageView를 업데이트하는 리스너 등록
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageSelection(_:)), name: NSNotification.Name("ImageSelected"), object: nil)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 100),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonNext.topAnchor, constant: -20),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonNext.heightAnchor.constraint(equalToConstant: 40),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func buttonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cosmeticIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleButtonCell", for: indexPath) as! CircleButtonCell
        let image = UIImage(named: cosmeticIcons[indexPath.item])
        cell.setImage(image)
        
        // Reset the cell to its default state
        cell.setSelected(false)
        
        // Highlight the selected cell
        if indexPath == selectedCellIndex {
            cell.setSelected(true)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let totalPadding = padding * 5
        let availableWidth = collectionView.frame.width - totalPadding
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // 이미지 선택 시 실행되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedCellIndex {
            // Deselect the previously selected cell
            let previousCell = collectionView.cellForItem(at: previousIndex) as? CircleButtonCell
            previousCell?.setSelected(false)
        }
        
        // Select the new cell
        let cell = collectionView.cellForItem(at: indexPath) as! CircleButtonCell
        cell.setSelected(true)
        selectedCellIndex = indexPath
        
        guard let image = cell.iconImageView.image else { return }
        imageView.image = image
    }
    
    // 이미지 선택 알림을 받아 imageView를 업데이트하는 메서드
    @objc func handleImageSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedImage = userInfo["image"] as? UIImage else { return }
        imageView.image = selectedImage
    }
}

class CircleButtonCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .setlightgreen
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            iconImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 이미지 설정 메서드
    func setImage(_ image: UIImage?) {
        iconImageView.image = image
    }
    
    // 선택 상태 업데이트 메서드
    func setSelected(_ selected: Bool) {
        if selected {
            containerView.layer.borderColor = UIColor.orange.cgColor
            containerView.layer.borderWidth = 2.0
            containerView.layer.shadowColor = UIColor.gray.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            containerView.layer.shadowOpacity = 0.7
            containerView.layer.shadowRadius = 4.0
        } else {
            containerView.layer.borderColor = UIColor.clear.cgColor
            containerView.layer.borderWidth = 0.0
            containerView.layer.shadowColor = UIColor.clear.cgColor
            containerView.layer.shadowOpacity = 0.0
        }
    }
}
