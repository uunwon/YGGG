//
//  FireBase.swift
//  YGGG
//
//  Created by Song Kim on 6/11/24.
//

import Firebase
import Foundation
import FirebaseFirestore

//class User: Codable {
//    let email: String
//    let uid: String
//    var userCosmetics: [UserCosmetics]
//    var userHashTag: String?
//    var userImage: String?
//    let userName: String
//    var bookmarkList: [String]
//
//    init(email: String, uid: String, userCosmetics: [UserCosmetics], userHashTag: String? = nil, userImage: String? = nil, userName: String, bookmarkList: [String]) {
//        self.email = email
//        self.uid = uid
//        self.userCosmetics = userCosmetics
//        self.userHashTag = userHashTag
//        self.userImage = userImage
//        self.userName = userName
//        self.bookmarkList = bookmarkList
//    }
//}

class UserCosmetics: Codable {
    var expirationDate: Timestamp
    var purchaseDate: Timestamp
    var title: String
    var category: String
    var imageName: String
    var kind: Int

    init(expirationDate: Timestamp, purchaseDate: Timestamp, title: String, category: String, imageName: String, kind: Int) {
        self.expirationDate = expirationDate
        self.purchaseDate = purchaseDate
        self.title = title
        self.category = category
        self.imageName = imageName
        self.kind = kind
    }
}
