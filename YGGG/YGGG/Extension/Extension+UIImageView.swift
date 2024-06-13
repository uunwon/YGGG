//
//  Extension+UIImageView.swift
//  YGGG
//
//  Created by Chung Wussup on 6/11/24.
//

import UIKit


extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("loadImage2   Invalid URL")
            return
        }
        
        // 비동기적으로 URL에서 이미지를 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("No data or failed to create image")
                return
            }
            
            // 메인 스레드에서 UIImageView에 이미지를 설정
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
