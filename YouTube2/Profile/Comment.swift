//
//  Comment.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 07.04.2024.
//

import Foundation
struct Comment {
    
    let uid = UUID().uuidString
    let user: User
    let commentText: String
    let time: String
    
    init(user: User?, dictionary: [String:Any]) {
        self.user = user ?? User(uid: nil, dictionary: dictionary["user"] as? [String: Any])
        self.commentText = dictionary["commentText"] as? String ?? ""
        self.time = dictionary["time"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["commentText"] = commentText
        dictionary["time"] = time
        dictionary["user"] = user.toDictionary()
        return dictionary
    }
}

extension Comment: Hashable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
