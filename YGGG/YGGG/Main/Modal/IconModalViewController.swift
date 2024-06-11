//
//  IconModalViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/8/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class IconModalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewModel: ModalViewModel
    var selectedCellIndex: IndexPath?
    
    let cosmeticIcons = ["brush", "clipboard", "comb", "cream-jar", "eye-liner", "facial-mask", "hand-sanitizer", "lip-balm", "lip-balm", "lip", "lipstick", "lotion", "cream", "mascara", "mirror", "mist", "nail-polish", "nail", "form", "perfume", "shaver", "soap", "spray", "serum", "sunscreen", "tube"]
    
    init(viewModel: ModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        updateNextButtonState()
    }
}

// MARK: - button & collectionview
extension IconModalViewController {
    
    @objc func buttonTapped() {
        viewModel.userCosmetic.imageName = cosmeticIcons[selectedCellIndex?.row ?? 0]
        
        let userCosmetic = viewModel.userCosmetic
            viewModel.userCosmetics.append(userCosmetic)
            ModalViewModel().addNewCosmetic(userCosmetic)
            viewModel.reloadAction?()
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateNextButtonState() {
        if imageView.image == UIImage(named: "icon_modal") {
            buttonNext.isEnabled = false
            buttonNext.backgroundColor = .systemGray6
        } else {
            buttonNext.isEnabled = true
            buttonNext.backgroundColor = .setorange
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cosmeticIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleButtonCell", for: indexPath) as! CircleButtonCell
        let image = UIImage(named: cosmeticIcons[indexPath.item])
        
        cell.setImage(image)
        cell.setSelected(false)
        
        if indexPath == selectedCellIndex {
            cell.setSelected(true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let totalPadding = padding * 5
        let availableWidth = collectionView.frame.width - totalPadding
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedCellIndex {
            let previousCell = collectionView.cellForItem(at: previousIndex) as? CircleButtonCell
            previousCell?.setSelected(false)
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CircleButtonCell
        cell.setSelected(true)
        selectedCellIndex = indexPath
        
        guard let image = cell.iconImageView.image else { return }
        imageView.image = image
        
        updateNextButtonState()
    }
    
    @objc func handleImageSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedImage = userInfo["image"] as? UIImage else { return }
        imageView.image = selectedImage
    }
}
