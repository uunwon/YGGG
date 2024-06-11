//
//  BookmarkTableViewCellViewModel.swift
//  YGGG
//
//  Created by 김영훈 on 6/11/24.
//

import Foundation

class BookmarkTableViewCellViewModel {
    
    let uid: String
    let userPhotoURL: String?
    let username: String
    let userHashTag: String?
    let refrigeratorCount: Int
    let graveCount: Int
    var isBookmarked: Bool
    
    init(user: User, bookmarkList: [String]) {
        self.uid = user.uid
        self.userPhotoURL = user.userImage
        self.username = user.userName
        self.userHashTag = user.userHashTag
        
        let refrigeratorItems = user.userCosmetics.filter { $0.expirationDate.dateValue() >= Date() }
        let graveItems = user.userCosmetics.filter { $0.expirationDate.dateValue() < Date() }
        
        self.refrigeratorCount = refrigeratorItems.count
        self.graveCount = graveItems.count
        self.isBookmarked = bookmarkList.contains(user.uid)
    }
}
