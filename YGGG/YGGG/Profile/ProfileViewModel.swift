//
//  ProfileViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/14/24.
//

import Foundation
import FirebaseAuth

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
    
    func getUserHashTag() -> String {
        return user?.userHashTag ?? ""
    }
    
    func getUserImage() -> String {
        return user?.userImage ?? ""
    }
    
    func getUserUid() -> String {
        return user?.uid ?? ""
    }
    
    func getFavoriteState(completion: @escaping (Bool) -> Void) {
        guard let otherUserUid = self.user?.uid,
              let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        service.getFavoriteState(uid: uid, otherUid: otherUserUid) { isFavorite in
            completion(isFavorite)
        }
        
    }
    
    func userFavorite(completion: @escaping(Bool) -> Void) {
        guard let otherUserUid = self.user?.uid,
                let uid = Auth.auth().currentUser?.uid else { return }

        service.userFavorite(uid: uid, otherUid: otherUserUid) { favorite in
            completion(favorite)
        }
        
    }
    
}
