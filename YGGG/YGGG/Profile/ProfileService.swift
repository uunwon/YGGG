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
    
    func getData(completion: @escaping(User) -> Void) {
        
        RED_USERS.document("NuAyZbv5uPYZYCTJb6kqYHziFRq2").getDocument { (document, error) in
            
            //            if let document = document, document.exists {
            //
            //                do {
            //                    if let data = document.data() {
            //                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            //                        let decoder = JSONDecoder()
            //                        let user = try decoder.decode(User.self, from: jsonData)
            //
            //                        completion(user)
            //                    }
            //                } catch let error {
            //                    print("Error converting document data to JSON: \(error.localizedDescription)")
            //                }
            //            } else {
            //                print("Document does not exist")
            //            }
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
                        decoder.dateDecodingStrategy = .iso8601
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
}
