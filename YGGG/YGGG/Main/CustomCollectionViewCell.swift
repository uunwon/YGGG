//
//  CustomCollectionViewCell.swift
//  YGGG
//
//  Created by Song Kim on 6/4/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let name = "CustomCollectionViewCell"
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let purchaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(purchaseDateLabel)
        addSubview(expirationDateLabel)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            purchaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            purchaseDateLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            purchaseDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            expirationDateLabel.topAnchor.constraint(equalTo: purchaseDateLabel.bottomAnchor, constant: 5),
            expirationDateLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            expirationDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configureHome() {
        productImageView.image = UIImage(resource: .llotion)
        titleLabel.text = "로션"
        purchaseDateLabel.text = "구매날짜: "
        expirationDateLabel.text = "유통기한: "
    }
    
    func configureGrave() {
        productImageView.image = UIImage(resource: .grave)
        titleLabel.text = "무덤"
        purchaseDateLabel.text = "구매날짜: "
        expirationDateLabel.text = "유통기한: "
    }
}
