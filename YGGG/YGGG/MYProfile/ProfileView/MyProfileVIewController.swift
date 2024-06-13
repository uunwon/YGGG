//
//  MyProfileVIewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit

class MyProfileVIewController: UIViewController{
    
    private let mainProfileView = ProfileMainView()
    private let viewModel = MyProfileViewModel()
    
    private lazy var settingTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.isScrollEnabled = false
        tv.estimatedRowHeight = 40
        tv.rowHeight = UITableView.automaticDimension
        tv.register(MyProfileTableViewCell.self, forCellReuseIdentifier: "MyProfileTableViewCell")
        tv.separatorStyle = .none
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setupData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mainProfileView)
        
        mainProfileView.delegate = self
        
        mainProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        [mainProfileView, settingTableView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainProfileView.heightAnchor.constraint(equalToConstant: 130),
            
            settingTableView.topAnchor.constraint(equalTo: mainProfileView.bottomAnchor),
            settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
    
    
    private func setupData()  {
        viewModel.getData { user in
            self.mainProfileView.setupUI(userImage: user.userImage, userName: user.userName,
                                         tombCount: user.refrigeratorCount,
                                         refrigeratorCount: user.tombCount,
                                         hashTag: user.email, isMyProfile: true)
            
        }
        
    }
    
}

extension MyProfileVIewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell", for: indexPath) as? MyProfileTableViewCell {
            
            switch indexPath.row {
            case 0:
                cell.settingCell(iconHidden: true, title: "설정")
            case 1:
                cell.settingCell(iconImageName: "settingUser", title: "계정")
            case 2:
                cell.settingCell(iconImageName: "bell", title: "알림")
            case 3:
                cell.settingCell(iconImageName: "question", title: "문의")
            case 4:
                cell.settingCell(iconImageName: "powerOff", title: "로그아웃")
            case 5:
                cell.settingCell(subInfo: false)
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let vc = AccountViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            viewModel.authLogout {
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                sceneDelegate.moveToSplash()
            }
        default:
            break
        }
    }
    
    
}

extension MyProfileVIewController: ProfileMainViewDelegate {
    func profileImageTapped() {
        let vc = MyProfileEditViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func favoriteTapped() {
    }
    
}

extension MyProfileVIewController: MyProfileEditDelegate {
    func changeUserDate(image: UIImage, name: String) {
        self.mainProfileView.changeUserData(image: image, name: name)
    }
}
