//
//  DateModalViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/8/24.
//

import UIKit
import FirebaseFirestore

protocol ModalDelegate: AnyObject {
    func onDismissReload(selection: String)
}

// MARK: main

class DateModalViewController: UIViewController {
    let viewModel: ModalViewModel
    
    init(viewModel: ModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "date_modal"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "어디서 / 언제까지 ?"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    let buttonNext: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .setorange
        button.tintColor = .black
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    
    let saveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "보관"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let selectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "선택"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .setneworange
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "유통기한"
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(saveButton)
        
        saveButton.addSubview(saveLabel)
        saveButton.addSubview(selectionLabel)
        
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.addSubview(buttonNext)
        
        buttonNext.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            saveButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            
            saveLabel.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: 20),
            saveLabel.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            selectionLabel.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: -20),
            selectionLabel.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            datePicker.heightAnchor.constraint(equalToConstant: 80),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            buttonNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonNext.heightAnchor.constraint(equalToConstant: 40),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        updateNextButtonState()
    }
}

// MARK: - button actions

extension DateModalViewController {
    @objc func buttonTapped() {
        let nextView = IconModalViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(nextView, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .setneworange  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        viewModel.userCosmetic.kind = viewModel.selectedIndex ?? 0
        viewModel.userCosmetic.expirationDate = Timestamp(date: datePicker.date)
    }
    
    @objc func saveButtonTapped() {
        let vc = OptionTableViewController(viewModel: viewModel)
        vc.delegate = self

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(vc, animated: true)
    }
    
    func updateNextButtonState() {
        if selectionLabel.text == "선택" {
            buttonNext.isEnabled = false
            buttonNext.backgroundColor = .systemGray6
        } else {
            buttonNext.isEnabled = true
            buttonNext.backgroundColor = .setorange
        }
    }
}

// MARK: - modal delegate

extension DateModalViewController: ModalDelegate {
    func onDismissReload(selection: String) {
        self.selectionLabel.text = selection
        updateNextButtonState()
    }
}
