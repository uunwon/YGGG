//
//  BookmarkTableViewCell.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit

protocol BookmarkTableViewModelDelegate {
    func toggleBookmark(uid: String, completion: @escaping (Bool) -> Void) async
}

class BookmarkTableViewCell: UITableViewCell {
    
    var delegate: BookmarkTableViewModelDelegate?
    var bookmarkCellViewModel: BookmarkTableViewCellViewModel?
    
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
    
    private lazy var refrigeratorCountLabel: UILabel = {
        let refrigeratorCountLabel = UILabel()
        refrigeratorCountLabel.text = "0"
        refrigeratorCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return refrigeratorCountLabel
    }()
    
    private lazy var graveCountLabel: UILabel = {
        let graveCountLabel = UILabel()
        graveCountLabel.text = "0"
        graveCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return graveCountLabel
    }()
    
    private lazy var userItemCountStackView: UIStackView = {
        let refrigeratorLabel = UILabel()
        refrigeratorLabel.text = "냉장고"
        refrigeratorLabel.font = UIFont.systemFont(ofSize: 12)
        
        let graveLabel = UILabel()
        graveLabel.text = "무덤"
        graveLabel.font = UIFont.systemFont(ofSize: 12)
        
        let userItemCountStackView = UIStackView(arrangedSubviews: [refrigeratorLabel, refrigeratorCountLabel, graveLabel, graveCountLabel])
        userItemCountStackView.axis = .horizontal
        userItemCountStackView.spacing = 5
        userItemCountStackView.alignment = .leading
        userItemCountStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return userItemCountStackView
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
        contentView.addSubview(userItemCountStackView)
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
            
            userItemCountStackView.topAnchor.constraint(equalTo: userHashTagLabel.bottomAnchor, constant: 3),
            userItemCountStackView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
        ])
    }
   
    func configureCell() {
        guard let viewModel = self.bookmarkCellViewModel else { return }
        
        if let photoURL = viewModel.userPhotoURL, photoURL != "" {
            loadImage(from: photoURL)
            
        } else {
            userPhotoView.image = UIImage(named: "userPhoto")
        }
        
        usernameLabel.text = viewModel.username
        userHashTagLabel.text = viewModel.userHashTag
        refrigeratorCountLabel.text = "\(viewModel.refrigeratorCount)"
        graveCountLabel.text = "\(viewModel.graveCount)"
        
        bookmarkToggleButton.setImage(UIImage(systemName: viewModel.isBookmarked ? "heart.fill" : "heart"), for: .normal)
        bookmarkToggleButton.removeTarget(nil, action: nil, for: .allEvents)
        bookmarkToggleButton.addAction(UIAction { [weak self] _ in
            Task {
                if let delegate = self?.delegate {
                    await delegate.toggleBookmark(uid: viewModel.uid) { newState in
                        DispatchQueue.main.async {
                            self?.bookmarkToggleButton.setImage(UIImage(systemName: newState ? "heart.fill" : "heart"), for: .normal)
                        }
                    }
                }
            }
        }, for: .touchUpInside)
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("loadImage Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No data or failed to create image")
                return
            }
            
            DispatchQueue.main.async {
                self.userPhotoView.image = image
            }
        }.resume()
    }
}
