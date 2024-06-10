//
//  BookmarkTableViewCell.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit
protocol BookmarkTableViewControllerDelegate {
    func toggleBookmark(index: Int)
}

class BookmarkTableViewCell: UITableViewCell {
    
    var delegate: BookmarkTableViewControllerDelegate?
    
    private lazy var userPhotoView: UIImageView = {
        let userPhotoView = UIImageView()
        userPhotoView.image = UIImage(named: "userPhoto")
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
        bookmarkToggleButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
            userPhotoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            userPhotoView.widthAnchor.constraint(equalToConstant: 65),
            userPhotoView.heightAnchor.constraint(equalToConstant: 65),
            
            bookmarkToggleButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 29),
            bookmarkToggleButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
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
    
    func configureCell(userInfoEntry: UserInfoEntry, index: Int) {
        var refrigeratorItems: [[String: String]] = []
        var graveItems: [[String: String]] = []
        
        usernameLabel.text = userInfoEntry.name
        userHashTagLabel.text = userInfoEntry.hashTags.reduce("") {
            $0 + " " + $1
        }
        
        for item in userInfoEntry.items {
            if let expirationDateString = item["expirationDate"] {
                if expirationDateString > "20240605" {
                    refrigeratorItems.append(item)
                } else {
                    graveItems.append(item)
                }
            }
        }
        userItemCountLabel.text = "냉장고 \(refrigeratorItems.count) 무덤 \(graveItems.count)"
        
        bookmarkToggleButton.removeTarget(nil, action: nil, for: .allEvents)
        bookmarkToggleButton.addAction(UIAction { [weak self] _ in
            if let delegate = self?.delegate {
                delegate.toggleBookmark(index: index)
            }
        }, for: .touchUpInside)
    }
}
