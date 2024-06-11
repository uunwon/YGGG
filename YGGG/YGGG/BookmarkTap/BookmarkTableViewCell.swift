//
//  BookmarkTableViewCell.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit
protocol BookmarkTableViewControllerDelegate {
    func toggleBookmark(uid: String, completion: @escaping (Bool) -> Void) async
}

class BookmarkTableViewCell: UITableViewCell {
    
    var delegate: BookmarkTableViewControllerDelegate?
    
    private lazy var userPhotoView: UIImageView = {
        let userPhotoView = UIImageView()
        userPhotoView.layer.cornerRadius = 32.5
        userPhotoView.layer.borderWidth = 2.0
        userPhotoView.layer.borderColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).cgColor
        userPhotoView.clipsToBounds = true
        userPhotoView.translatesAutoresizingMaskIntoConstraints = false
        return userPhotoView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        return usernameLabel
    }()
    
    private lazy var userHashTagLabel: UILabel = {
        let userHashTagLabel = UILabel()
        userHashTagLabel.font = UIFont.systemFont(ofSize: 12)
        userHashTagLabel.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)
        userHashTagLabel.translatesAutoresizingMaskIntoConstraints = false
        return userHashTagLabel
    }()
    
    private lazy var userItemCountLabel: UILabel = {
        let userItemCountLabel = UILabel()
        userItemCountLabel.font = UIFont.systemFont(ofSize: 12)
        userItemCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return userItemCountLabel
    }()
    
    private lazy var bookmarkToggleButton: UIButton = {
        let bookmarkToggleButton = UIButton()
        bookmarkToggleButton.tintColor = UIColor(red: 135/255, green: 200/255, blue: 188/255, alpha: 1)
        bookmarkToggleButton.contentHorizontalAlignment = .fill
        bookmarkToggleButton.contentVerticalAlignment = .fill
        bookmarkToggleButton.imageView?.contentMode = .scaleAspectFit
        bookmarkToggleButton.translatesAutoresizingMaskIntoConstraints = false
        return bookmarkToggleButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(userPhotoView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(userHashTagLabel)
        contentView.addSubview(userItemCountLabel)
        contentView.addSubview(bookmarkToggleButton)
        
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            userPhotoView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 11),
            userPhotoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            userPhotoView.widthAnchor.constraint(equalToConstant: 65),
            userPhotoView.heightAnchor.constraint(equalToConstant: 65),
            
            bookmarkToggleButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 29),
            bookmarkToggleButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            bookmarkToggleButton.widthAnchor.constraint(equalToConstant: 23),
            bookmarkToggleButton.heightAnchor.constraint(equalToConstant: 23),
            
            usernameLabel.topAnchor.constraint(equalTo: userPhotoView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userPhotoView.trailingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(equalTo: bookmarkToggleButton.leadingAnchor, constant: -3),
            
            userHashTagLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3),
            userHashTagLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            userHashTagLabel.trailingAnchor.constraint(equalTo: bookmarkToggleButton.leadingAnchor, constant: -3),
            
            userItemCountLabel.topAnchor.constraint(equalTo: userHashTagLabel.bottomAnchor, constant: 3),
            userItemCountLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            userItemCountLabel.trailingAnchor.constraint(equalTo: bookmarkToggleButton.leadingAnchor, constant: -3)
        ])
    }
    
    func configureCell(user: User, bookmarkList: [String]) {
        var refrigeratorItems: [UserCosmetics] = []
        var graveItems: [UserCosmetics] = []
        
        if let photoURL = user.userImage, photoURL != "" {
            loadImage(from: photoURL)
            
        } else {
            userPhotoView.image = UIImage(named: "userPhoto")
        }
        
        usernameLabel.text = user.userName
        userHashTagLabel.text = user.userHashTag
        
        for cosmetic in user.userCosmetics {
            if cosmetic.expirationDate.dateValue() < Date() {
                graveItems.append(cosmetic)
            } else {
                refrigeratorItems.append(cosmetic)
            }
        }
        userItemCountLabel.text = "냉장고 \(refrigeratorItems.count) 무덤 \(graveItems.count)"
        
        let isBookmarked = bookmarkList.contains(user.uid)
        bookmarkToggleButton.setImage(UIImage(systemName: isBookmarked ? "heart.fill" : "heart"), for: .normal)
        bookmarkToggleButton.removeTarget(nil, action: nil, for: .allEvents)
        bookmarkToggleButton.addAction(UIAction { [weak self] _ in
            Task {
                if let delegate = self?.delegate {
                    await delegate.toggleBookmark(uid: user.uid) { newState in
                        DispatchQueue.main.async {
                            self?.bookmarkToggleButton.setImage(UIImage(systemName: newState ? "heart.fill" : "heart"), for: .normal)
                        }
                    }
                }
            }
        }, for: .touchUpInside)
    }
    //예시코드
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
                self.userPhotoView.image = image
            }
        }.resume()
    }
}
