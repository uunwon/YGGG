//
//  KindModalViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/7/24.
//

import UIKit

struct Cosmetic {
    let name: String
}

struct CosmeticCategory {
    let category: String
    let cosmetics: [Cosmetic]
}

class KindModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let categories: [CosmeticCategory] = [
        CosmeticCategory(category: "기초", cosmetics: [
            Cosmetic(name: "스킨"),
            Cosmetic(name: "토너"),
            Cosmetic(name: "에센스"),
            Cosmetic(name: "앰플"),
            Cosmetic(name: "세럼"),
            Cosmetic(name: "로션"),
            Cosmetic(name: "크림"),
            Cosmetic(name: "마스크팩"),
            Cosmetic(name: "토너패드")
        ]),
        CosmeticCategory(category: "색조", cosmetics: [
            Cosmetic(name: "립스틱"),
            Cosmetic(name: "틴트"),
            Cosmetic(name: "립밤"),
            Cosmetic(name: "블러셔"),
            Cosmetic(name: "섀도우"),
            Cosmetic(name: "라이너"),
            Cosmetic(name: "마스카라"),
            Cosmetic(name: "브로우")
        ]),
        CosmeticCategory(category: "피부", cosmetics: [
            Cosmetic(name: "파운데이션"),
            Cosmetic(name: "쿠션"),
            Cosmetic(name: "선크림"),
            Cosmetic(name: "컨실러")
        ]),
        CosmeticCategory(category: "씻을 때", cosmetics: [
            Cosmetic(name: "클렌징 오일"),
            Cosmetic(name: "클렌징 폼"),
            Cosmetic(name: "면도크림")
        ])
    ]
    
    var selectedKind: String?
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "kind_modal"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "화장품 종류 선택"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("다음", for: .normal)
        button.tintColor = .black
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(tableView)
        view.addSubview(buttonNext)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        buttonNext.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: buttonNext.topAnchor, constant: -20),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        updateButtonState()
    }
    
    @objc func buttonTapped() {
        let nextView = DateModalViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].cosmetics.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].category
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.section].cosmetics[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cosmetic = categories[indexPath.section].cosmetics[indexPath.row].name
        buttonNext.isEnabled = true
        updateButtonState()
    }
    
    func updateButtonState() {
        if buttonNext.isEnabled {
            buttonNext.backgroundColor = .setorange
        } else {
            buttonNext.backgroundColor = .setlightgray
        }
    }
}
