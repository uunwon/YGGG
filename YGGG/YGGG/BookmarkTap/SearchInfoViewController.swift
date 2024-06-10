//
//  SearchInfoViewController.swift
//  YGGG
//
//  Created by 김영훈 on 6/5/24.
//

import UIKit

class SearchInfoViewController: UIViewController {
    private lazy var label : UILabel = {
       let label = UILabel()
        label.numberOfLines = 3
        label.text = "검색 \n관련 \n설명"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLabel()
        
        self.preferredContentSize = CGSize(width: 200, height: 200)
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
        ])
    }
}
