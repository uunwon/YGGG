//
//  ProfileViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/6/24.
//

import Foundation
import Firebase

struct TopCategory: Codable {
    let imageName: String
    let title: String
}
struct User: Codable {
    let userImage: String
    let userName: String
    let uid: String
    let userHashTag: String
    let bookmarkList: [String]
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

        // purchaseDate를 Timestamp로 디코딩 후 String으로 변환
        if let timestamp = try? container.decode(Timestamp.self, forKey: .purchaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            purchaseDate = dateFormatter.string(from: timestamp.dateValue())
        } else {
            purchaseDate = try container.decode(String.self, forKey: .purchaseDate)
        }

        // expirationDate를 Timestamp로 디코딩 후 String으로 변환
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

class ProfileViewModel {
    
    let service: ProfileService = ProfileService()

    private var user: User?
    
    init(user: User) {
        self.user = user
    }
    ///MockUp Data
    private var topCategorys: [TopCategory] = [
        TopCategory(imageName: "allmenu", title: "전체"),
        TopCategory(imageName: "snowflake", title: "냉동"),
        TopCategory(imageName: "fridge", title: "냉장"),
        TopCategory(imageName: "body", title: "실온")
    ]
    
    ///return Category Count [ 전체, 냉동, 냉장, 실온 ]
    func topCateogoryCount() -> Int {
        return topCategorys.count
    }
    
    func getCategoryItem(index: Int) -> TopCategory {
        return topCategorys[index]
    }

    
    func loadData(completion: @escaping() -> Void) {
        guard let uid = user?.uid else { return }
        self.service.getData(uid: uid) { [weak self] user in
            guard let self = self else { return }
            self.user = user
            self.selectedCosmeticList = user.userCosmetics
            completion()
        }
    }
    
    
    private lazy var selectedCosmeticList: [Cosmetics] = []
    
    private func addDate(add: Int) -> Date {
        let addDay = Calendar.current.date(byAdding: .day, value: add, to: Date())
        return addDay!
    }
    
    private func minusDate(minus: Int) -> Date {
        let minusDate = Calendar.current.date(byAdding: .day, value: -minus, to: Date())
        return minusDate!
    }
    
    
    func cosmeticsCount() -> Int {
        return self.selectedCosmeticList.count
    }
    
    func getCosmetic(index: Int) -> Cosmetics {
        return self.selectedCosmeticList[index]
    }
    
    func getSectionCosmetic(caseType: Int, completion: @escaping() -> Void ) {
        switch caseType {
        case 1:
            selectedCosmeticList = user?.userCosmetics.filter { $0.kind == 0 } ?? []
        case 2:
            selectedCosmeticList = user?.userCosmetics.filter { $0.kind == 1 } ?? []
        case 3:
            selectedCosmeticList = user?.userCosmetics.filter { $0.kind == 2 } ?? []
        default:
            selectedCosmeticList = user?.userCosmetics ?? []
        }
        completion()
    }
    
    
    func getUserTombCount() -> Int {
        return user?.tombCount ?? 0
    }
    
    func getUserRefrigeratorCount() -> Int {
        return user?.refrigeratorCount ?? 0
    }
    
    func getUserName() -> String {
        return user?.userName ?? ""
    }
    
    //    func getUserHashTag() -> [String] {
    func getUserHashTag() -> String {
        return user?.userHashTag ?? ""
    }
    
    func getUserImage() -> String {
        return user?.userImage ?? ""
    }
    
    func getUserUid() -> String {
        return user?.uid ?? ""
    }

}
