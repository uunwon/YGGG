//
//  FireBase.swift
//  YGGG
//
//  Created by Song Kim on 6/11/24.
//

import Firebase
import Foundation
import FirebaseFirestore

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
