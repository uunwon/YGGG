//
//  ViewModelBookmarkTable.swift
//  YGGG
//
//  Created by 김영훈 on 6/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class BookmarkTableViewModel {
    var datas: [User] = []
    var bookmarkList: [String] = []
    var myID = ""
    
    var onDataChanged: (() -> Void)?
    
    init() {
        Task {
            await loadActiveUserID()
        }
    }
    
    private func loadActiveUserID() async {
        let user = Auth.auth().currentUser
        if let user = user {
            myID = user.uid
        }
    }
    
    func loadBookmarkList() async {
        do {
            let db = Firestore.firestore()
            let activeUserDocRef = db.collection("users").document(myID)
            let activeUserData = try await activeUserDocRef.getDocument(as: User.self)
        
            bookmarkList = activeUserData.bookmarkList
            
            if !(activeUserData.bookmarkList.isEmpty) {
                var loadedDatas: [User] = []
                let snapshot = try await db.collection("users").whereField("uid", in: bookmarkList).getDocuments()
                for document in snapshot.documents {
                    if let data = try? document.data(as: User.self) {
                        loadedDatas.append(data)
                    }
                }
                
                self.datas = loadedDatas
            } else {
                self.datas = []
            }
            DispatchQueue.main.async {
                self.onDataChanged?()
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    func loadFilteredList(searchText: String) async {
        do {
            let db = Firestore.firestore()
            let snapshotByName = try await db.collection("users")
                .whereField("userName", isGreaterThanOrEqualTo: searchText)
                .whereField("userName", isLessThanOrEqualTo: searchText + "\u{f7ff}")
                .getDocuments()
            
            var loadedDatas: [User] = []
            for document in snapshotByName.documents {
                if let data = try? document.data(as: User.self) {
                    loadedDatas.append(data)
                }
            }
            
            self.datas = loadedDatas
            DispatchQueue.main.async {
                self.onDataChanged?()
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
}

extension BookmarkTableViewModel: BookmarkTableViewModelDelegate {
    func toggleBookmark(uid: String, completion: @escaping (Bool) -> Void) async {
        do {
            let isBookmarked: Bool
            if bookmarkList.contains(uid) {
                bookmarkList = bookmarkList.filter { $0 != uid }
                isBookmarked = false
            } else {
                bookmarkList.append(uid)
                isBookmarked = true
            }
            
            let db = Firestore.firestore()
            let activeUserDocRef = db.collection("users").document(myID)
            try await activeUserDocRef.updateData(["bookmarkList" : bookmarkList])
            
            completion(isBookmarked)
        } catch {
            print("Error toggling documents: \(error)")
        }
    }
}
