//
//  MyProfileVIewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit
import MessageUI

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
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["nadana0929@gmail.com"]) // 받는 사람 이메일 주소
            mailComposeVC.setSubject("문의 사항") // 이메일 제목
            mailComposeVC.setMessageBody("여기에 내용을 입력하세요.", isHTML: false) // 이메일 본문
            
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "메일 설정 오류", message: "이메일 계정을 설정해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        case 3:
            self.sendEmail()
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

extension MyProfileVIewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .cancelled:
            print("사용자가 이메일 작성을 취소했습니다.")
        case .saved:
            print("이메일이 임시 저장되었습니다.")
        case .sent:
            print("이메일이 발송되었습니다.")
        case .failed:
            print("이메일 전송에 실패했습니다.")
        @unknown default:
            print("알 수 없는 오류가 발생했습니다.")
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
