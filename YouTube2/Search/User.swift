//
//  User.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 28.01.2024.
//

import UIKit

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String?, dictionary: [String:Any]?) {
        self.uid = uid ?? (dictionary?["uid"] as? String ?? "")
        self.username = dictionary?["username"] as? String ?? ""
        self.profileImageUrl = dictionary?["profileImageUrl"] as? String ?? ""
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["uid"] = uid
        dictionary["username"] = username
        dictionary["profileImageUrl"] = profileImageUrl
        return dictionary
    }
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}
