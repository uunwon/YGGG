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
    
    func getData(completion: @escaping(User) -> Void) {
        guard let uid = auth?.uid else { return }
        RED_USERS.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    if var data = document.data() {
                        // Convert FIRTimestamp to formatted date string
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        
                        if let userCosmetics = data["userCosmetics"] as? [[String: Any]] {
                            var updatedUserCosmetics = [[String: Any]]()
                            for var cosmetic in userCosmetics {
                                if let expirationDate = cosmetic["expirationDate"] as? Timestamp {
                                    cosmetic["expirationDate"] = dateFormatter.string(from: expirationDate.dateValue())
                                }
                                if let purchaseDate = cosmetic["purchaseDate"] as? Timestamp {
                                    cosmetic["purchaseDate"] = dateFormatter.string(from: purchaseDate.dateValue())
                                }
                                updatedUserCosmetics.append(cosmetic)
                            }
                            data["userCosmetics"] = updatedUserCosmetics
                        }
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: jsonData)
                        
                        completion(user)
                    }
                } catch let error {
                    print("Error converting document data to JSON: \(error.localizedDescription)")
                }
            } else {
                print("Document does not exist")
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
