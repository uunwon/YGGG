//
//  ModalViewModel.swift
//  YGGG
//
//  Created by Song Kim on 6/10/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ModalViewModel {
    var userCosmetics = [UserCosmetics]()
    
    let options = ["냉동", "냉장", "실온"]
    
    var selectedIndex: Int? = nil
    
    private var userRef: DocumentReference? {
        if let userUUID = Auth.auth().currentUser?.uid {
            return RED_USERS.document(userUUID)
        }
        return nil
    }
    
    func addNewCosmetic(_ viewModel: UserCosmetics) {
        let cosmetic: [String: Any] = [
            "imageName": viewModel.imageName,
            "title": viewModel.title,
            "purchaseDate": viewModel.purchaseDate,
            "expirationDate": viewModel.expirationDate,
            "kind": viewModel.kind,
            "category": viewModel.category
        ]
        
        userRef?.updateData(["userCosmetics": FieldValue.arrayUnion([cosmetic])]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Update success")
            }
        }
    }
    
    func loadCosmetic() {
        userRef?.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let documentSnapshot = documentSnapshot, let data = documentSnapshot.data() else {
                print("No document data found")
                return
            }
            
            if let cosmeticsData = data["userCosmetics"] as? [[String: Any]] {
                var cosmetics = [UserCosmetics]()
                for cosmeticData in cosmeticsData {
                    if let imageName = cosmeticData["imageName"] as? String,
                       let title = cosmeticData["title"] as? String,
                       let purchaseDateTimestamp = cosmeticData["purchaseDate"] as? Timestamp,
                       let expirationDateTimestamp = cosmeticData["expirationDate"] as? Timestamp,
                       let kind = cosmeticData["kind"] as? Int,
                       let category = cosmeticData["category"] as? String {
                        let cosmetic = UserCosmetics(expirationDate: expirationDateTimestamp, purchaseDate: purchaseDateTimestamp, title: title, category: category, imageName: imageName, kind: kind)
                        cosmetics.append(cosmetic)
                    }
                }
                self.userCosmetics = cosmetics
                self.reloadAction?()
            }
        }
    }
    
    var userCosmetic = UserCosmetics(expirationDate: Timestamp(date: Date()), purchaseDate: Timestamp(date: Date()), title: "", category: "", imageName: "", kind: 0)
    
    var selectedOption: String {
        if let selectedIndex {
            return options[selectedIndex]
        } else {
            return "선택"
        }
    }
    
    var reloadAction: (() -> Void)? = nil

}
