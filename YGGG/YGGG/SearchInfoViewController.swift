//
//  SearchInfoViewController.swift
//  YGGG
//
//  Created by 김영훈 on 6/5/24.
//

import UIKit

class SearchInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "검색 \n관련 \n설명"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
        ])
        
        self.preferredContentSize = CGSize(width: 200, height: 200)
    }
}
