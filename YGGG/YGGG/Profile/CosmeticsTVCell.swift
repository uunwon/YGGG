//
//  CosmeticsTVCell.swift
//  YGGG
//
//  Created by Chung Wussup on 6/5/24.
//

import UIKit

class CosmeticsTVCell: UITableViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 248/255, green: 245/255, blue: 245/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let cosmeticsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cosmaticsImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        
        return sv
    }()
    
    
    let cosmeticLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let dateStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        
        return sv
    }()
    
    let purchaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func configureUI() {
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 137)
        ])
        
        mainView.addSubview(cosmeticsView)
        NSLayoutConstraint.activate([
            cosmeticsView.widthAnchor.constraint(equalToConstant: 80),
            cosmeticsView.heightAnchor.constraint(equalToConstant: 80),
            cosmeticsView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            cosmeticsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 23),
        
        ])
        
        cosmeticsView.addSubview(cosmaticsImageView)
        NSLayoutConstraint.activate([
            cosmaticsImageView.centerXAnchor.constraint(equalTo: cosmeticsView.centerXAnchor),
            cosmaticsImageView.centerYAnchor.constraint(equalTo: cosmeticsView.centerYAnchor),
            
            cosmaticsImageView.topAnchor.constraint(equalTo: cosmeticsView.topAnchor, constant: 20),
            cosmaticsImageView.leadingAnchor.constraint(equalTo: cosmeticsView.leadingAnchor, constant: 20),
            cosmaticsImageView.trailingAnchor.constraint(equalTo: cosmeticsView.trailingAnchor,constant: -20),
            cosmaticsImageView.bottomAnchor.constraint(equalTo: cosmeticsView.bottomAnchor, constant: -20)
        ])
        
        
        mainView.addSubview(mainStackView)
        
        [cosmeticLabel, dateStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [purchaseDateLabel, expirationDateLabel].forEach {
            dateStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([

            mainStackView.leadingAnchor.constraint(equalTo: cosmeticsView.trailingAnchor, constant: 18),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -5),
            mainStackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        ])
        
    }
    
    
    func configureCell(cosmetic: Cosmetics) {
        let image: UIImage?
        if cosmetic.isExpired {
            image = UIImage(named: cosmetic.imageName)
            cosmeticsView.backgroundColor = .gray
            
        } else {
            image = UIImage(named: cosmetic.imageName)
            cosmeticsView.backgroundColor = .yggg_green
            
        }
        
        cosmaticsImageView.image = image
        
        cosmeticLabel.text = cosmetic.title
        purchaseDateLabel.text = "종류: \(cosmetic.category)"
        expirationDateLabel.text = "유통기한: \(cosmetic.expirationDate)"
    }
    
}
