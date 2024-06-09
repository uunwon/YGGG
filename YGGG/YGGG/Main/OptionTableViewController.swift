//
//  OptionTableViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/9/24.
//

import UIKit

import UIKit

class OptionTableViewController: UIViewController {
    
    let selectedOption: String
    
    init(selectedOption: String) {
        self.selectedOption = selectedOption
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "선택한 옵션: \(selectedOption)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
