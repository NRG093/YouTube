//
//  Post.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 18.02.2024.
//

import Foundation

struct Post {
    
    var id: String?
    
    let user: User?
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    var hasLiked = false
    var likedUsers: [String: String]
    init(user: User?, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondFrom1970)
        self.id = dictionary["id"] as? String ?? ""
        self.likedUsers = dictionary["likedUsers"] as? [String: String] ?? [String: String]()
    }
}

extension Post: Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.user == rhs.user && lhs.caption == rhs.caption && lhs.imageUrl == rhs.imageUrl && lhs.creationDate == rhs.creationDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
