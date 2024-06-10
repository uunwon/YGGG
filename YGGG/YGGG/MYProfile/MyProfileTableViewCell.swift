//
//  MyProfileTableViewCell.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private let basicStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 22, bottom: 10, right: 22)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let subStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    
    private let subMainTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "“우리 삶의 가장 소중한 순간들은 냉장고 앞에서 이루어진다.”"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
   
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chat GPT"
        label.textColor = .appGreen
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
  
    
  

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        [basicStackView, subStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [iconImageView, titleLabel].forEach {
            basicStackView.addArrangedSubview($0)
        }
        
        [subMainTitleLabel, subTitleLabel].forEach {
            subStackView.addArrangedSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 21),
            iconImageView.widthAnchor.constraint(equalToConstant: 21),
            
            titleLabel.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor)
            
        ])
        
    }
    
    func settingCell(iconHidden: Bool = false, iconImageName: String = "", title: String = "", subInfo: Bool = true) {
        
        if subInfo {
            basicStackView.isHidden = false
            subStackView.isHidden = true
     
            iconImageView.isHidden = iconHidden
            
            if !iconHidden {
                iconImageView.image = UIImage(named: iconImageName)
            }
            
            titleLabel.text = title
            
        } else {
            basicStackView.isHidden = true
            subStackView.isHidden = false
          
        }
        
    }
    
}
