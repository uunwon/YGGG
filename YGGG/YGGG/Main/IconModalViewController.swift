//
//  IconModalViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/8/24.
//

import UIKit

class IconModalViewController: UIViewController {

    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_modal"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "모양 선택"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("추가", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .black
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
 //       button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        buttonNext.addTarget(self, action: #selector(ButtonTapped), for: .touchUpInside)
        view.addSubview(buttonNext)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        updateButtonColor()
    }
    
    @objc func ButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateButtonColor() {
         
    }

}
