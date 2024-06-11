//
//  MyProfileVIewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class MyProfileVIewController: UIViewController{

    
    private let mainProfileView = ProfileMainView()
    private let auth = Auth.auth().currentUser
    
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
        configureUI()
        configureDataSetup()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureUI() {
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
    
    
    private func configureDataSetup()  {
        
        if let _ = self.auth {
            getData { user in
                self.mainProfileView.setupUI(userImage: user.userImage, userName: user.userName,
                                        tombCount: user.tombCount, refrigeratorCount: user.refrigeratorCount,
                                        hashTag: user.email, isMyProfile: true)
                
            }
            
        }
    }
    
    
    private func attributeButtonText(title: String, count: Int) -> NSAttributedString{
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10)
        ]
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10)
        ]
        
        let attributedString = NSMutableAttributedString(string: title, attributes: normalAttributes)
        let countString = NSAttributedString(string: "\(count)", attributes: boldAttributes)
        
        attributedString.append(countString)
        return attributedString
    }
    
    func getData(completion: @escaping(User) -> Void) {
        guard let uid = auth?.uid else { return }
        RED_USERS.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if var data = document.data() {
                        // Convert FIRTimestamp to formatted date string
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        
                        if let userCosmetics = data["userCosmetics"] as? [[String: Any]] {
                            var updatedUserCosmetics = [[String: Any]]()
                            for var cosmetic in userCosmetics {
                                if let expirationDate = cosmetic["expirationDate"] as? Timestamp {
                                    cosmetic["expirationDate"] = dateFormatter.string(from: expirationDate.dateValue())
                                }
                                if let purchaseDate = cosmetic["purchaseDate"] as? Timestamp {
                                    cosmetic["purchaseDate"] = dateFormatter.string(from: purchaseDate.dateValue())
                                }
                                updatedUserCosmetics.append(cosmetic)
                            }
                            data["userCosmetics"] = updatedUserCosmetics
                        }
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: jsonData)
                        
                        completion(user)
                    }
                } catch let error {
                    print("Error converting document data to JSON: \(error.localizedDescription)")
                }
            } else {
                print("Document does not exist")
            }
            
        }
        
    }
    
}

extension MyProfileVIewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileTableViewCell", for: indexPath) as? MyProfileTableViewCell {
            switch indexPath.row {
            case 0:
                cell.settingCell(iconHidden: true, title: "설정")
            case 1:
                cell.settingCell(iconImageName: "settingUser", title: "계정")
            case 2:
                cell.settingCell(iconImageName: "monitor", title: "화면")
            case 3:
                cell.settingCell(iconImageName: "bell", title: "알림")
            case 4:
                cell.settingCell(iconImageName: "question", title: "문의")
            case 5:
                cell.settingCell(iconImageName: "powerOff", title: "로그아웃")
            case 6:
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
        case 5:
            print("logout")
            do {
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance.signOut()
                GIDSignIn.sharedInstance.disconnect()
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                sceneDelegate.moveToSplash()
            } catch {
                print("logout error")
            }
        default:
            break
        }
    }
    
    
}

extension MyProfileVIewController: ProfileMainViewDelegate {
    func profileImageTapped() {
        print("profileImageTapped")
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
