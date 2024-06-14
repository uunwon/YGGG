//
//  ProfileViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/6/24.
//

import Foundation
import Firebase
import FirebaseAuth

struct TopCategory: Codable {
    let imageName: String
    let title: String
}
struct User: Codable {
    let userImage: String
    let userName: String
    let uid: String
    let userHashTag: String
    var bookmarkList: [String]
    let snsRoot: String
    
    var refrigeratorCount: Int {
        return userCosmetics.filter { $0.expirationDateAsDate < Date() }.count
    }
    var tombCount: Int {
        return userCosmetics.filter { $0.expirationDateAsDate > Date() }.count
    }
    let email: String
    let userCosmetics: [Cosmetics]
}



struct Cosmetics: Codable {
    let imageName: String
    let title: String
    let purchaseDate: String
    let expirationDate: String
    let kind: Int // 0: 냉동, 1: 냉장, 2: 실온
    let category: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    
    private var inputDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter
    }
    
    
    var isExpired: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = dateFormatter.date(from: expirationDate) {
            return date < Date()
        }
        return false
    }
    
    var purchaseString: String {
        return purchaseDate
    }
    
    var expirationString: String {
        return expirationDate
    }
    
    var expirationDateAsDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = dateFormatter.date(from: expirationDate) {
            return date
        }
        return Date()
    }
    enum CodingKeys: String, CodingKey {
        case imageName, title, purchaseDate, expirationDate, kind, category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageName = try container.decode(String.self, forKey: .imageName)
        title = try container.decode(String.self, forKey: .title)
        
        if let timestamp = try? container.decode(Timestamp.self, forKey: .purchaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            purchaseDate = dateFormatter.string(from: timestamp.dateValue())
        } else {
            purchaseDate = try container.decode(String.self, forKey: .purchaseDate)
        }
        
        if let timestamp = try? container.decode(Timestamp.self, forKey: .expirationDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            expirationDate = dateFormatter.string(from: timestamp.dateValue())
        } else {
            expirationDate = try container.decode(String.self, forKey: .expirationDate)
        }
        
        kind = try container.decode(Int.self, forKey: .kind)
        category = try container.decode(String.self, forKey: .category)
    }
}

