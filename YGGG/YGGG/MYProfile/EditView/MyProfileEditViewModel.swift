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

    
    func getData(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
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
    
    func saveUserData(hashTags: [String], userName: String, userImage: UIImage, compltion: @escaping() -> Void) {
        uploadImageToFirebase(userImage)
        updateUserName(newUserName: userName)
        updateUserHashTags(hashTags: hashTags)
        
        compltion()
    }
    
    func updateUserHashTags(hashTags: [String]) {
        let hashTagsString = hashTags.joined(separator: " ")
        if let uid = Auth.auth().currentUser?.uid {
            COLLECTION_USERS.document(uid).updateData(["userHashTag": hashTagsString]) { error in
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
            COLLECTION_USERS.document(uid).updateData(["userName": newUserName]) { error in
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
           
           // 고유한 파일 이름 생성
           let imageName = UUID().uuidString
           let imageRef = STORAGE_REF.child("images/\(imageName).jpg")
           
           // Firebase Storage에 이미지 업로드
           imageRef.putData(imageData) { metadata, error in
               if let error = error {
                   print("Error uploading image: \(error)")
                   return
               }
               
               // 이미지 다운로드 URL 가져오기
               imageRef.downloadURL { url, error in
                   if let error = error {
                       print("Error getting download URL: \(error)")
                       return
                   }
                   
                   guard let downloadURL = url else {
                       print("Download URL not found")
                       return
                   }
                   
                   // Firestore에 이미지 URL 업데이트
                   self.updateUserImageURL(downloadURL.absoluteString)
               }
           }
       }
       
       func updateUserImageURL(_ url: String) {
           // Firestore 문서의 UID
           if let uid = Auth.auth().currentUser?.uid {
               // Firestore 문서 업데이트
               COLLECTION_USERS.document(uid).updateData(["userImage": url]) { error in
                   if let error = error {
                       print("Error updating user image URL: \(error)")
                   } else {
                       print("User image URL successfully updated")
                   }
               }
           }
       }
}

