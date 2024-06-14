//
//  MyProfileEditViewModel.swift
//  YGGG
//
//  Created by Chung Wussup on 6/11/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

let STORAGE_REF = Storage.storage().reference()

class MyProfileEditViewModel {
    
    
    func getData(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        RED_USERS.document(uid).getDocument { (document, error) in
            guard let document = document, document.exists, var data = document.data() else {
                print("Document does not exist or error occurred")
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            data["userCosmetics"] = (data["userCosmetics"] as? [[String: Any]])?.map { cosmetic in
                var updatedCosmetic = cosmetic
                ["expirationDate", "purchaseDate"].forEach { key in
                    if let timestamp = updatedCosmetic[key] as? Timestamp {
                        updatedCosmetic[key] = dateFormatter.string(from: timestamp.dateValue())
                    }
                }
                return updatedCosmetic
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
    
    func saveUserData(hashTags: [String], userName: String, userImage: UIImage, compltion: @escaping() -> Void) {
        uploadImageToFirebase(userImage)
        updateUserName(newUserName: userName)
        updateUserHashTags(hashTags: hashTags)
        
        compltion()
    }
    
    func updateUserHashTags(hashTags: [String]) {
        let hashTagsString = hashTags.joined(separator: " ")
        if let uid = Auth.auth().currentUser?.uid {
            RED_USERS.document(uid).updateData(["userHashTag": hashTagsString]) { error in
                if let error = error {
                    print("Error updating user image URL: \(error)")
                } else {
                    print("User image URL successfully updated")
                }
            }
        }
    }
    
    func updateUserName(newUserName: String) {
        if let uid = Auth.auth().currentUser?.uid {
            RED_USERS.document(uid).updateData(["userName": newUserName]) { error in
                if let error = error {
                    print("Error updating user image URL: \(error)")
                } else {
                    print("User image URL successfully updated")
                }
            }
        }
    }
    
    
    func uploadImageToFirebase(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error converting image to JPEG")
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = STORAGE_REF.child("images/\(imageName).jpg")
        
        imageRef.putData(imageData) { _, error in
            guard error == nil else {
                print("Error uploading image: \(error!)")
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    print("Error getting download URL: \(error!)")
                    return
                }
                
                self.updateUserImageURL(downloadURL.absoluteString)
            }
        }
    }
    
    func updateUserImageURL(_ url: String) {
        // Firestore 문서의 UID
        if let uid = Auth.auth().currentUser?.uid {
            // Firestore 문서 업데이트
            RED_USERS.document(uid).updateData(["userImage": url]) { error in
                if let error = error {
                    print("Error updating user image URL: \(error)")
                } else {
                    print("User image URL successfully updated")
                }
            }
        }
    }
}

