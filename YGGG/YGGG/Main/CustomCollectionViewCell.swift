//
//  CustomCollectionViewCell.swift
//  YGGG
//
//  Created by Song Kim on 6/4/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let name = "CustomCollectionViewCell"
    
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let categoryLabel: UILabel = {
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
    
    private func setupViews() {
        addSubview(colorView)
        colorView.addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(expirationDateLabel)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 60),
            colorView.heightAnchor.constraint(equalToConstant: 60),
            
            productImageView.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            productImageView.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 40),
            productImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            expirationDateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            expirationDateLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            expirationDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with cosmetic: UserCosmetic, isHomeTab: Bool) {
        productImageView.image = UIImage(named: cosmetic.imageName)
        titleLabel.text = cosmetic.title
        categoryLabel.text = "종류: \(cosmetic.category)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        expirationDateLabel.text = "유통기한: \(dateFormatter.string(from: cosmetic.expirationDate))"
        
        if isHomeTab {
            colorView.backgroundColor = .setlightgreen
        } else {
            colorView.backgroundColor = .gray
        }
    }
}
