//
//  MyProfileEditViewController.swift
//  YGGG
//
//  Created by Chung Wussup on 6/10/24.
//

import UIKit

protocol MyProfileEditDelegate: AnyObject {
    func changeUserDate(image: UIImage, name: String)
}

class MyProfileEditViewController: UIViewController {
    private let viewModel = MyProfileEditViewModel()
    weak var delegate: MyProfileEditDelegate?
    
    
    private let imageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "user")
        iv.layer.cornerRadius = 60
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    private let cameraImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "camera")
        return iv
    }()
    
    
    private let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 10
        sv.axis = .vertical
        sv.layoutMargins = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이름"
        return label
    }()
    
    private let nickNameTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "이름을 입력하세요."
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let hashTagMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hashTagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let fullText = "해시태그(최대 4개)"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.black
        ]
        attributedString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: 3))
        
        let specialAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.lightGray
        ]
        let specialTextRange = (fullText as NSString).range(of: "(최대 4개)")
        attributedString.addAttributes(specialAttributes, range: specialTextRange)
        
        label.attributedText = attributedString
        return label
    }()
    
    
    private lazy var hashTagTF: UITextField = {
        let tf = UITextField()
        
        let fullText = "태그를 입력하세요(최대 4글자)"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        attributedString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: 3))
        
        let specialAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10)
        ]
        let specialTextRange = (fullText as NSString).range(of: "(최대 4글자)")
        attributedString.addAttributes(specialAttributes, range: specialTextRange)
        
        tf.attributedPlaceholder = attributedString
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private lazy var tagAddButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.backgroundColor = .yggg_teal
        button.addTarget(self, action: #selector(addHashTagButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var hashTagCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 110, height: 76)
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(HashTagCVCell.self, forCellWithReuseIdentifier: "HashTagCVCell")
        return cv
    }()
    
    var hashTags: [String] = [] {
        didSet{
            hashTagCV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .setneworange
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        setupUI()
        getUserData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setupUI() {
  
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = .white
        navigationItem.title = "프로필"
        
        let rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain,
                                                 target: self, action: #selector(saveButtonTapped))
        rightBarButtonItem.tintColor = .setneworange
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.navigationBar.backgroundColor = .white

        
        view.addSubview(imageViewContainer)
        
        [profileImageView, cameraImageView].forEach {
            imageViewContainer.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            profileImageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor),
            profileImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor,
                                                  constant: 39),
            profileImageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor,
                                                     constant: -39),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            
            cameraImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                      constant: -10),
            cameraImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            cameraImageView.heightAnchor.constraint(equalToConstant: 26),
            cameraImageView.widthAnchor.constraint(equalToConstant: 26)
        ])
        
        view.addSubview(infoStackView)
        
        [nickNameLabel, nickNameTF, hashTagLabel, hashTagMainView, hashTagCV].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        [hashTagTF, tagAddButton].forEach {
            hashTagMainView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: imageViewContainer.bottomAnchor,
                                               constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            
            nickNameLabel.heightAnchor.constraint(equalToConstant: 15),
            nickNameTF.heightAnchor.constraint(equalToConstant: 48),
            hashTagTF.heightAnchor.constraint(equalToConstant: 48),
            
            
            hashTagMainView.heightAnchor.constraint(equalToConstant: 56),
            hashTagLabel.heightAnchor.constraint(equalToConstant: 15),
            
            hashTagTF.centerYAnchor.constraint(equalTo: hashTagMainView.centerYAnchor),
            hashTagTF.leadingAnchor.constraint(equalTo: hashTagMainView.leadingAnchor),
            hashTagTF.trailingAnchor.constraint(equalTo: tagAddButton.leadingAnchor,
                                                constant: -10),
            
            tagAddButton.centerYAnchor.constraint(equalTo: hashTagMainView.centerYAnchor),
            tagAddButton.trailingAnchor.constraint(equalTo: hashTagMainView.trailingAnchor),
            
            tagAddButton.heightAnchor.constraint(equalToConstant: 48),
            tagAddButton.widthAnchor.constraint(equalToConstant: 76),
            
            hashTagCV.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
            
        ])
        
    }
    
    private func getUserData() {
        
        viewModel.getData { [weak self] user in
            self?.profileImageView.loadImage(from: user.userImage)
            self?.nickNameTF.text = user.userName
            self?.hashTags = user.userHashTag.components(separatedBy: " ").filter { !$0.isEmpty }
        }
        
    }
    
    
    @objc private func saveButtonTapped() {
        if let userName = nickNameTF.text, let userImage = profileImageView.image {
            viewModel.saveUserData(hashTags: hashTags, userName: userName, userImage: userImage) {
                
                self.delegate?.changeUserDate(image: userImage, name: userName)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @objc func imageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func addHashTagButtonTapped() {
        if hashTags.count < 4 {
            if let hashTag = hashTagTF.text, !(hashTag.isEmpty) {
                hashTags.append("#\(hashTag)")
                hashTagTF.text = nil
                hashTagCV.reloadData()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension MyProfileEditViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return hashTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCVCell",
                                                         for: indexPath) as? HashTagCVCell {
            cell.configureCell(hashtag: hashTags[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension MyProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지 선택이 완료되었을 때 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지 가져오기
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 이미지 선택을 취소했을 때 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MyProfileEditViewController: HashTagCellDelegate {
    func deleteHashTag(hashTag: String) {
        if hashTags.contains(hashTag) {
            
            if let firstIndex = hashTags.firstIndex(of: hashTag) {
                hashTags.remove(at: firstIndex)
                
                self.hashTagCV.reloadData()
            }
        }
    }
}

extension MyProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addHashTagButtonTapped()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // 입력된 텍스트가 유효한지 확인
        guard let char = string.cString(using: String.Encoding.utf8) else { return true }
        let backSpace = strcmp(char, "\\b")
        
        // 텍스트의 길이가 10 이상이면서 백스페이스가 아닌 경우
        if textField.text!.count >= 4 {
            if backSpace != -92 {
                // 받침 여부에 따라 입력 제어
                if !postPositionText(textField.text!) && isConsonant(Character(string)) {
                    // 받침이 없는 경우 자음 입력 제어
                    if textField.text!.utf16.count + string.count >= 5 {
                        return !isVowel(Character(string))
                    }
                } else if postPositionText(textField.text!) && !isConsonant(Character(string)) {
                    // 받침이 있는 경우 모음 입력
                    guard let lastText = textField.text!.last else { return false }
                    if isConsonant(lastText) {
                        return true
                    } else {
                        return textField.text!.count > 5 ? isVowel(Character(string)) : false
                    }
                } else {
                    return false
                }
            }
        }
        
        return true
    }
    
    //마지막 글자가 한글인지 확인, 한글이 아닐경우 true 반환, 한글일 경우 받침이 있으면 true 없으면 false 반환
    func postPositionText(_ inputText: String) -> Bool {
        // 글자의 마지막 부분을 가져옴
        guard let lastText = inputText.last else { return true }
        // 유니코드 전환
        let unicodeVal = UnicodeScalar(String(lastText))?.value
        
        guard let value = unicodeVal else { return true }
        // 한글아니면 반환
        if (value < 0xAC00 || value > 0xD7A3) { return true }
        // 종성인지 확인
        let last = (value - 0xAC00) % 28
        // 받침없으면 true 있으면 false
        let str = last > 0
        
        return str
    }
    
    // 텍스트가 자음인지 확인
    func isConsonant(_ character: Character) -> Bool {
        let unicodeScalarValue = character.unicodeScalars.first!.value
        // 'ㄱ'(0x3131)부터 'ㅎ'(0x314E)까지가 자음의 유니코드 범위
        return unicodeScalarValue >= 0x3131 && unicodeScalarValue <= 0x314E
    }
    
    
    //텍스트가 모음인지 확인
    func isVowel(_ character: Character) -> Bool {
        let unicodeScalarValue = character.unicodeScalars.first!.value
        return (unicodeScalarValue >= 0x314F && unicodeScalarValue <= 0x3163) || unicodeScalarValue == 0x318D
    }
    
}
