//
//  ProfileViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/6/24.
//

import Foundation
import Firebase


struct User: Codable {
    let userImage: String
    let userName: String
    let uid: String
    let userHashTag: String
    let bookmarkList: [String]
    let snsRoot: String
    
    var refrigeratorCount: Int {
        return userCosmetics.filter { $0.expirationDateAsDate > Date() }.count
    }
    var tombCount: Int {
        return userCosmetics.filter { $0.expirationDateAsDate < Date() }.count
    }
    //    var isFavorite: Bool = false
    let email: String
    let userCosmetics: [Cosmetics]
}

struct TopCategory: Codable {
    let imageName: String
    let title: String
}

struct Cosmetics: Codable {
    let imageName: String
    let title: String
    let purchaseDate: Timestamp
    let expirationDate: Timestamp
    let kind: Int // 0: 냉동, 1: 냉장, 2: 실온
    let category: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    
    private var inputDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter
    }
    
    
    var isExpired: Bool {
//        guard let expirationDate = dateFormatter.date(from: expirationDate) else { return false }
        let expirationDate = expirationDate.dateValue()
        return expirationDate < Date()
    }
    
    var purchaseString: String {
//        guard let purchaseDate = inputDateFormatter.date(from: purchaseDate) else { return "Invalid date" }
        let purchaseDate = purchaseDate.dateValue()
        return dateFormatter.string(from: purchaseDate)
    }
    
    var expirationString: String {
//        guard let expirationDate = inputDateFormatter.date(from: expirationDate) else { return "Invalid date" }
        let expirationDate = expirationDate.dateValue()
        return dateFormatter.string(from: expirationDate)
    }
    
    var expirationDateAsDate: Date {
//        return dateFormatter.date(from: expirationDate) ?? Date()
        return expirationDate.dateValue()
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

}
