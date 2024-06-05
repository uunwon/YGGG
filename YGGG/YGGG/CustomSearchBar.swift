//
//  CustomSearchBar.swift
//  YGGG
//
//  Created by 김영훈 on 6/5/24.
//

import SwiftUI

class CustomSearchBar: UISearchBar {
    
    var infoButton: UIButton = {
        let infoButton = UIButton(type: .infoLight)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        return infoButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInfoButton()
        removeSearchBarBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInfoButton() {
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            infoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 26),
            infoButton.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func removeSearchBarBackground() {
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
}
