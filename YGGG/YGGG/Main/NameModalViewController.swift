//
//  ModalView.swift
//  YGGG
//
//  Created by Song Kim on 6/5/24.
//

import UIKit

class NameModalViewController: UIViewController, UITextFieldDelegate {
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "name_modal"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "화장품 이름"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "화장품 이름을 입력하세요"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .setlightgray2
        textField.addTarget(self, action: #selector(updateButtonColor), for: .editingChanged)
        return textField
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("다음", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(textField)
        
        buttonNext.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        view.addSubview(buttonNext)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        updateButtonColor()
    }
    
    // UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when the return key is pressed
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Optional: Handle any logic when the text field begins editing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Optional: Handle any logic when the text field ends editing
    }
    
    @objc func ButtonTapped() {
        let nextView = KindModalViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc func updateButtonColor() {
        if let text = textField.text, !text.isEmpty {
            buttonNext.isEnabled = true
            buttonNext.backgroundColor = .setorange
        } else {
            buttonNext.isEnabled = false
            buttonNext.backgroundColor = .setlightgray
        }
         
    }
    
}
