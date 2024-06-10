//
//  KindModalViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/7/24.
//

import UIKit

// MARK: main

class KindModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedKind: String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        // 테이블 뷰의 헤더뷰 설정 (이미지뷰와 레이블 추가)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 140))
        let imageView = UIImageView(image: UIImage(named: "kind_modal"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "화장품 종류 선택"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
        
        tableView.tableHeaderView = headerView
        
        return tableView
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(buttonNext)
        
        buttonNext.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonNext.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonNext.heightAnchor.constraint(equalToConstant: 40),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        updateButtonState()
    }
}

// MARK: - button actions & tableview

extension KindModalViewController {
    // '다음' 버튼 탭 시 동작
    @objc func ButtonTapped() {
        let nextView = DateModalViewController()
        navigationController?.pushViewController(nextView, animated: true)

        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // 섹션 개수 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    // 각 섹션의 행 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].cosmetics.count
    }
    
    // 각 섹션의 헤더 제목 반환
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].category
    }
    
    // 각 행의 셀 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.section].cosmetics[indexPath.row].name
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    // 셀 선택 시 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = categories[indexPath.section].cosmetics[indexPath.row].name
        buttonNext.isEnabled = true
        updateButtonState()
    }
    
    // 버튼 상태 업데이트
    func updateButtonState() {
        if buttonNext.isEnabled {
            buttonNext.backgroundColor = .setorange
        } else {
            buttonNext.backgroundColor = .systemGray5
        }
    }
}
