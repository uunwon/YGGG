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

let categories: [CosmeticCategory] = [
    CosmeticCategory(category: "기초", cosmetics: [
        Cosmetic(name: "스킨"),
        Cosmetic(name: "토너"),
        Cosmetic(name: "에센스"),
        Cosmetic(name: "앰플"),
        Cosmetic(name: "세럼"),
        Cosmetic(name: "로션"),
        Cosmetic(name: "크림"),
        Cosmetic(name: "마스크팩"),
        Cosmetic(name: "토너패드")
    ]),
    CosmeticCategory(category: "색조", cosmetics: [
        Cosmetic(name: "립스틱"),
        Cosmetic(name: "틴트"),
        Cosmetic(name: "립밤"),
        Cosmetic(name: "블러셔"),
        Cosmetic(name: "섀도우"),
        Cosmetic(name: "라이너"),
        Cosmetic(name: "마스카라"),
        Cosmetic(name: "브로우")
    ]),
    CosmeticCategory(category: "피부", cosmetics: [
        Cosmetic(name: "파운데이션"),
        Cosmetic(name: "쿠션"),
        Cosmetic(name: "선크림"),
        Cosmetic(name: "컨실러")
    ]),
    CosmeticCategory(category: "씻을 때", cosmetics: [
        Cosmetic(name: "클렌징 오일"),
        Cosmetic(name: "클렌징 폼"),
        Cosmetic(name: "면도크림")
    ])
]

let cosmeticOptions = ["냉동", "냉장", "실온"]

let cosmeticIcons = ["brush", "clipboard", "comb", "cream-jar", "eye-liner", "facial-mask", "hand-sanitizer", "lip-balm", "lip-balm", "lip", "lipstick", "lotion", "cream", "mascara", "mirror", "mist", "nail-polish", "nail", "form", "perfume", "shaver", "soap", "spray", "serum", "sunscreen", "tube"]

struct userCosmetic {
    let expirationDate: Date
    let purchaseDate: Date
    let title: String
    let category: String
    let imageName: String
    let kind: Int
}







