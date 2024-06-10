//
//  CustomSearchBar.swift
//  YGGG
//
//  Created by 김영훈 on 6/5/24.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    lazy var infoButton: UIButton = {
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "information-button"), for: .normal)
        return infoButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInfoButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInfoButton() {
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            infoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 20),
            infoButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
}
