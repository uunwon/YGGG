//
//  Extension+UIButton.swift
//  YGGG
//
//  Created by uunwon on 6/19/24.
//

import UIKit

extension UIButton {
    func setImages(leftImage: UIImage?, rightImage: UIImage?, for state: UIControl.State) {
        
        // 왼쪽 이미지
        if let leftImage = leftImage {
            let leftImageView = UIImageView(image: leftImage)
            leftImageView.contentMode = .scaleAspectFit
            leftImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(leftImageView)
            
            NSLayoutConstraint.activate([
                leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                leftImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                leftImageView.widthAnchor.constraint(equalToConstant: 20),
                leftImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        // 오른쪽 이미지
        if rightImage != nil {
            let rightImageView = UIImageView(image: rightImage)
            rightImageView.tintColor = .lightGray
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(rightImageView)
            
            NSLayoutConstraint.activate([
                rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                rightImageView.widthAnchor.constraint(equalToConstant: 20),
                rightImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        // 중앙 텍스트
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
    }
}
