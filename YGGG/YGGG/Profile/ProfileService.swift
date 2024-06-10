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
            
            if let document = document, document.exists {
                
                do {
                    if let data = document.data() {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: jsonData)
                        print(user)
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
