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
    
    
    func fetchDocumentData(uid: String, completion: @escaping ([String]?) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { document, error in
            guard let document = document, document.exists,
                  let bookmarkList = document.data()?["bookmarkList"] as? [String] else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(bookmarkList)
        }
    }
    
    func getFavoriteState(uid: String, otherUid: String, completion: @escaping(Bool) -> Void) {
        fetchDocumentData(uid: uid) { bookmarkList in
            completion(bookmarkList?.contains(otherUid) ?? false)
        }
    }
    
    func updateBookmarkList(uid: String, bookmarkList: [String], completion: @escaping (Bool) -> Void) {
        COLLECTION_USERS.document(uid).updateData(["bookmarkList": bookmarkList]) { error in
            if let error = error {
                print("업데이트 에러, \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func userFavorite(uid: String, otherUid: String, completion: @escaping(Bool) -> Void) {
        fetchDocumentData(uid: uid) { bookmarkList in
            guard var bookmarkList = bookmarkList else { return }
            
            let isFavorite = bookmarkList.contains(otherUid)
            if isFavorite {
                bookmarkList.removeAll { $0 == otherUid }
            } else {
                bookmarkList.append(otherUid)
            }
            
            updateBookmarkList(uid: uid, bookmarkList: bookmarkList) { success in
                if success {
                    completion(!isFavorite)
                }
            }
        }
    }
}
