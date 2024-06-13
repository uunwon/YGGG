//
//  MyProfileViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/11/24.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn


class MyProfileViewModel {
    private let auth = Auth.auth().currentUser
    
    func getData(completion: @escaping (User) -> Void) {
        guard let uid = auth?.uid else { return }
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
    
    func authLogout(completion: @escaping() -> Void) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            GIDSignIn.sharedInstance.disconnect()
     
            completion()
        } catch {
            print("logout error")
        }
    }
    
}
