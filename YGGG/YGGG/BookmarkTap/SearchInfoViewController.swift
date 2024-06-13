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
        label.numberOfLines = 10
        label.text = "입력된 글자로 시작하는 이름을 가진 사용자를 검색할 수 있습니다.\n\n 대소문자를 구분합니다.\n\n검색어가 없을 시 북마크에 추가한 사용자가 표시됩니다."
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLabel()
        
        self.preferredContentSize = CGSize(width: 220, height: 130)
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}
