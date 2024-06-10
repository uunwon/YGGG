//
//  UserInfoEntry.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit

class UserInfoEntry {
    let name: String
    let email: String
    var hashTags: [String]
    var items: [[String : String]]
    
    init(name: String, email: String, hashTags: [String], items: [[String : String]]) {
        self.name = name
        self.email = email
        self.hashTags = hashTags
        self.items = items
    }
    
    static var sampleDatas: [UserInfoEntry] = [
        UserInfoEntry(name: "yunwon", email: "email@email.com", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [
            ["itemName" : "로션","expirationDate" : "20250605"],
            ["itemName" : "선크림","expirationDate" : "20240604"]
        ]),
        UserInfoEntry(name: "song", email: "email2@email.com", hashTags: ["#건조","#수부지","#민감성","#홍조"], items:[
            ["itemName" : "로션","expirationDate" : "20250605"],
        ]),
        UserInfoEntry(name: "yeonghun", email: "email@email.com", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [
            ["itemName" : "로션","expirationDate" : "20250605"],
            ["itemName" : "선크림","expirationDate" : "20240604"]
        ]),
        UserInfoEntry(name: "chunghyeon", email: "email2@email.com", hashTags: ["#건조","#수부지","#민감성","#홍조"], items:[
            ["itemName" : "로션","expirationDate" : "20250605"],
        ]),
        UserInfoEntry(name: "yunwon2", email: "email@email.com", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [
            ["itemName" : "로션","expirationDate" : "20250605"],
            ["itemName" : "선크림","expirationDate" : "20240604"]
        ]),
        UserInfoEntry(name: "song2", email: "email2@email.com", hashTags: ["#건조","#수부지","#민감성","#홍조"], items:[
            ["itemName" : "로션","expirationDate" : "20250605"],
        ])
    ]
}

