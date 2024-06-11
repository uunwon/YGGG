//
//  ModalViewModel.swift
//  YGGG
//
//  Created by Song Kim on 6/10/24.
//

import Foundation

class ModalViewModel {
    let options = cosmeticOptions
    var selectedIndex: Int? = nil
    
    var userCosmetics = [
        UserCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "녹두", category: "세럼",  imageName: "serum", kind: 0),
        UserCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "안넝", category: "세럼",  imageName: "sunscreen", kind: 0),
        UserCosmetic(expirationDate: Date(timeIntervalSinceNow: 60*60*24*365), purchaseDate: Date(), title: "우히히", category: "세럼",  imageName: "eye-liner", kind: 1),
        UserCosmetic(expirationDate: Date(timeIntervalSinceNow: -60*60*24*365), purchaseDate: Date(), title: "크림", category: "크림",  imageName: "lotion", kind: 2)
    ]
    
    var userCosmetic: UserCosmetic? = nil
    
    var selectedOption: String {
        if let selectedIndex {
            return options[selectedIndex]
        } else {
            return "선택"
        }
    }
    
    var reloadAction: (() -> Void)? = nil
}
