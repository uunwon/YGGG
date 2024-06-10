//
//  MyProfileVIewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit
import Firebase

class MyProfileVIewController: UIViewController{

    
    private let mainProfileView = ProfileMainView()
    
    
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
    
    
    private func configureDataSetup() {
        mainProfileView.setupUI(userImage: "", userName: "Ruel", tombCount: 20, refrigeratorCount: 10, hashTag: "#하이", isMyProfile: true)
        
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
        case 5:
            print("logout")
//            do {
//                try Auth.auth().signOut()
//                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
//                sceneDelegate.goToSplash()
//            } catch {
//                print("logout error")
//            }
        default:
            break
        }
    }
    
    
}

extension MyProfileVIewController: ProfileMainViewDelegate {
    func profileImageTapped() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        present(imagePickerController, animated: true)
        
        let vc = MyProfileEditViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func favoriteTapped() {
        //        viewModel.changeFavorite { [weak self] in
        //            self?.favoriteButtonSetup()
        //        }
    }
    
}
//
//extension MyProfileVIewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    
//        if let selectedImage = info[.originalImage] as? UIImage {
//            mainProfileView.changeImageView(image: selectedImage)
////            profileImageView.image = selectedImage
////            uploadImageToFirebase(selectedImage)
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
