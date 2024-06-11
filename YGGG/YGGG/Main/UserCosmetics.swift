//
//  UserCosmetics.swift
//  YGGG
//
//  Created by Song Kim on 6/9/24.
//

import UIKit

struct Cosmetic {
    let name: String
}

struct CosmeticCategory {
    let category: String
    let cosmetics: [Cosmetic]
}

let cosmeticOptions = ["냉동", "냉장", "실온"]

//struct UserCosmetic {
//    var expirationDate = Date()
//    var purchaseDate = Date()
//    var title = ""
//    var category = ""
//    var imageName = ""
//    var kind = 0
//}

