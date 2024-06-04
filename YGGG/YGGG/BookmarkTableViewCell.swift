//
//  BookmarkTableViewCell.swift
//  Lab8-temp
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    private lazy var userPhotoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userPhoto")
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
       let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return usernameLabel
    }()
    
    private lazy var userHashTagLabel: UILabel = {
        let userHashTagLabel = UILabel()
        userHashTagLabel.font = UIFont.systemFont(ofSize: 12)
        userHashTagLabel.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)
        return userHashTagLabel
    }()
    
    private lazy var userItemCountLabel: UILabel = {
       let userItemCountLabel = UILabel()
        userItemCountLabel.font = UIFont.systemFont(ofSize: 12)
        return userItemCountLabel
    }()
    
    private lazy var bookmarkHeartView: UIImageView = {
        let bookmarkHeartView = UIImageView()
        bookmarkHeartView.image = UIImage(systemName: "heart")!
        bookmarkHeartView.tintColor = UIColor(red: 135/255, green: 200/255, blue: 188/255, alpha: 1)
        return bookmarkHeartView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userPhotoView)
        addSubview(usernameLabel)
        addSubview(userHashTagLabel)
        addSubview(userItemCountLabel)
        addSubview(bookmarkHeartView)
        
        userPhotoView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        userHashTagLabel.translatesAutoresizingMaskIntoConstraints = false
        userItemCountLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarkHeartView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            userPhotoView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 11),
            userPhotoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            userPhotoView.widthAnchor.constraint(equalToConstant: 65),
            userPhotoView.heightAnchor.constraint(equalToConstant: 65),
            
            bookmarkHeartView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 29),
            bookmarkHeartView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bookmarkHeartView.widthAnchor.constraint(equalToConstant: 23),
            bookmarkHeartView.heightAnchor.constraint(equalToConstant: 23),
            
            usernameLabel.topAnchor.constraint(equalTo: userPhotoView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userPhotoView.trailingAnchor, constant: 15),
            usernameLabel.trailingAnchor.constraint(equalTo: bookmarkHeartView.leadingAnchor, constant: -3),
            
            userHashTagLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3),
            userHashTagLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            userHashTagLabel.trailingAnchor.constraint(equalTo: bookmarkHeartView.leadingAnchor, constant: -3),
            
            userItemCountLabel.topAnchor.constraint(equalTo: userHashTagLabel.bottomAnchor, constant: 3),
            userItemCountLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            userItemCountLabel.trailingAnchor.constraint(equalTo: bookmarkHeartView.leadingAnchor, constant: -3)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configureCell
    func configureCell(userInfoEntry: UserInfoEntry) {
        usernameLabel.text = userInfoEntry.name
        userHashTagLabel.text = userInfoEntry.hashTags.reduce("") {
            $0 + " " + $1
        }
        userItemCountLabel.text = "냉장고 \(userInfoEntry.items.count)"
    }
}

//var view = UIView()
//view.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
//let image0 = UIImage(named: "user-10.png")?.cgImage
//let layer0 = CALayer()
//layer0.contents = image0
//layer0.bounds = view.bounds
//layer0.position = view.center
//view.layer.addSublayer(layer0)
//
//view.layer.cornerRadius = 40
//view.layer.borderWidth = 0.5
//view.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).cgColor
//
//var parent = self.view!
//parent.addSubview(view)
//view.translatesAutoresizingMaskIntoConstraints = false
//view.widthAnchor.constraint(equalToConstant: 65).isActive = true
//view.heightAnchor.constraint(equalToConstant: 65).isActive = true
//view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 24).isActive = true
//view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 121).isActive = true

