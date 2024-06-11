//
//  HashTagCVCell.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit

protocol HashTagCellDelegate: AnyObject {
    func deleteHashTag(hashTag: String)
}

class HashTagCVCell: UICollectionViewCell {
    
    weak var delegate: HashTagCellDelegate?
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appPrimary.cgColor
        return view
    }()
    
    private lazy var hashTagDeleteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appPrimary
        button.addTarget(self, action: #selector(hashTagDeleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let hashTagLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleView)
        titleView.addSubview(hashTagLabel)
        titleView.addSubview(hashTagDeleteButton)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            hashTagLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            hashTagLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            hashTagLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            hashTagLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),

            
            hashTagDeleteButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 7),
            hashTagDeleteButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -39),
            hashTagDeleteButton.heightAnchor.constraint(equalToConstant: 26),
            hashTagDeleteButton.widthAnchor.constraint(equalToConstant: 26)
        
        ])
        
    }
    
    func configureCell(hashtag: String) {
        hashTagLabel.text = hashtag
    }
    
    @objc private func hashTagDeleteButtonTapped() {
        if let hashTag = hashTagLabel.text {
            delegate?.deleteHashTag(hashTag: hashTag)
        }
        
    }
    
}
