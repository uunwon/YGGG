//
//  UserInfoEntry.swift
//  YGGG
//
//  Created by 김영훈 on 6/4/24.
//

import UIKit

class UserInfoEntry {
    let name: String
    var hashTags: [String]
    var items: [Date]
    
    init(name: String, hashTags: [String], items: [Date]) {
        self.name = name
        self.hashTags = hashTags
        self.items = items
    }
    
    static var sampleDatas: [UserInfoEntry] = [
        UserInfoEntry(name: "yunwon", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [Calendar.current.date(byAdding: .day,  value: 2, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: 5, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -1, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -3, to: Date())!,
                                                                               ]),
        UserInfoEntry(name: "song", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [Calendar.current.date(byAdding: .day,  value: 2, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: 5, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -1, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -3, to: Date())!,
                                                                               ]),
        UserInfoEntry(name: "yeonghun", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [Calendar.current.date(byAdding: .day,  value: 2, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: 5, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -1, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -3, to: Date())!,
                                                                               ]),
        UserInfoEntry(name: "chungheon", hashTags: ["#건조","#수부지","#민감성","#홍조"], items: [Calendar.current.date(byAdding: .day,  value: 2, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: 5, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -1, to: Date())!,
                                                                                Calendar.current.date(byAdding: .day,  value: -3, to: Date())!,
                                                                               ])
    ]
}

