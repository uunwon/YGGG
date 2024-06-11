//
//  ProfileMainView.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit


protocol ProfileMainViewDelegate: AnyObject {
    func favoriteTapped()
    func profileImageTapped()
}

class ProfileMainView: UIView {
    weak var delegate: ProfileMainViewDelegate?
    
    private let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 38
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "user")
        return iv
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.favoriteTapped()
        }), for: .touchUpInside)
        return button
    }()
    
    private let profileStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 2
        sv.axis = .vertical
        return sv
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let cosmeticsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.spacing = 10
        sv.distribution = .fill
        return sv
    }()
    
    private let refrigeratorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let tombButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    private func setupUI() {
        backgroundColor = .white
        addSubview(profileView)
        
        [profileImageView, profileStackView, favoriteButton].forEach {
            addSubview($0)
        }
        
        [nickNameLabel, tagLabel, cosmeticsStackView].forEach {
            profileStackView.addArrangedSubview($0)
        }
        
        [refrigeratorButton, tombButton, emptyView].forEach {
            cosmeticsStackView.addArrangedSubview($0)
        }
        
        //profileView Constraint Setting
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        //profileImageView Constraint Setting
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 76),
            profileImageView.heightAnchor.constraint(equalToConstant: 76),
            profileImageView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 33),
            profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 32)
        ])
        
        //profileStackView Constraint Setting
        NSLayoutConstraint.activate([
            profileStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            profileStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -20)
            
        ])
        
        //favoriteButton Constraint Setting
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 23),
            favoriteButton.heightAnchor.constraint(equalToConstant: 23),
            favoriteButton.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 65),
            favoriteButton.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -42)
        ])
        
        
        
    }
    
    func changeUserData(image: UIImage, name: String) {
        profileImageView.image = image
        nickNameLabel.text = name
    }
    
    
    @objc private func favoriteTapped() {
        self.delegate?.favoriteTapped()
//        viewModel.changeFavorite { [weak self] in
//            self?.favoriteButtonSetup()
//        }
    }
    
    
    func setupUI(userImage: String, userName: String, tombCount: Int, refrigeratorCount: Int, hashTag: String, isMyProfile: Bool = false) {
        print(userImage)
        profileImageView.loadImage(from: userImage)
        nickNameLabel.text = userName
        
        tombButton.setAttributedTitle(self.attributeButtonText(title: "무덤: ", count: tombCount), for: .normal)
        refrigeratorButton.setAttributedTitle(self.attributeButtonText(title: "냉장고: ", count: refrigeratorCount), for: .normal)
        
        tagLabel.text = hashTag
        
        
        if isMyProfile {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            profileImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        delegate?.profileImageTapped()
    }
    
    
  
    
    private func attributeButtonText(title: String, count: Int) -> NSAttributedString{
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10)
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10)
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: normalAttributes)
        let countString = NSAttributedString(string: "\(count)", attributes: boldAttributes)
        
        attributedString.append(countString)
        return attributedString
    }
    
}



extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // 비동기적으로 URL에서 이미지를 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No data or failed to create image")
                return
            }
            
            // 메인 스레드에서 UIImageView에 이미지를 설정
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
