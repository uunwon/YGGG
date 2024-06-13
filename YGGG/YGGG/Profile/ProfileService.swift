//
//  ProfileService.swift
//  YGGG
//
//  Created by Chung Wussup on 6/8/24.
//

import Foundation
import Firebase


let DB_RED = Firestore.firestore()
let RED_USERS = DB_RED.collection("users")



struct ProfileService {
    
    static let shared = ProfileService()
    
    func getData(uid: String, completion: @escaping (User) -> Void) {
        RED_USERS.document(uid).getDocument { (document, error) in
            guard let document = document, document.exists, var data = document.data() else {
                print("Document does not exist or error occurred")
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            if let userCosmetics = data["userCosmetics"] as? [[String: Any]] {
                data["userCosmetics"] = userCosmetics.map { cosmetic in
                    var updatedCosmetic = cosmetic
                    ["expirationDate", "purchaseDate"].forEach { key in
                        if let timestamp = updatedCosmetic[key] as? Timestamp {
                            updatedCosmetic[key] = dateFormatter.string(from: timestamp.dateValue())
                        }
                    }
                    return updatedCosmetic
                }
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(user)
            } catch {
                print("Error converting document data to JSON: \(error.localizedDescription)")
            }
        }
    }
}
