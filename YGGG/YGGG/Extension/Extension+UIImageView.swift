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
            print("Invalid URL")
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        // 데이터 검색
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        
        // 네트워크 요청
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let response = response, let image = UIImage(data: data) else {
                print("No data , failed to load image")
                return
            }
            
            // 캐시 저장
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }.resume()
    }
}
