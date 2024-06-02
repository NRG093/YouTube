//
//  ProfileLikeViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 11.02.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileLikeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ProfileLikeCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileLikeCell
        let post = self.posts[indexPath.item]
        cell.descriptionLabel.text = Array(post.likedUsers.values).joined(separator: ", ") + " liked your post"
        cell.postImageView.kf.setImage(with: URL(string: post.imageUrl))
        let firstLikedUser = post.likedUsers.first?.key ?? ""
        let likedUserImage = users.first(where: {$0.uid == firstLikedUser})?.profileImageUrl ?? ""
        cell.logoImageView.kf.setImage(with: URL(string: likedUserImage))
        cell.followingButton.isHidden = true
        cell.postImageView.isHidden = !cell.followingButton.isHidden
           return cell
        }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchLikes()
        }
    
    var posts = [Post]()
    func fetchLikes() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let dataReference = Database.database().reference().child("posts").child(currentUser.uid)
        dataReference.observeSingleEvent(of: .value, with: { snapshot in
            guard let postsDictionary = snapshot.value as? [String: Any] else {return}
            for postDic in postsDictionary {
                guard let dictionary = postDic.value as? [String: Any] else {return}
                let post = Post(user: User(uid: currentUser.uid, dictionary: nil), dictionary: dictionary)
            
            let likedUsers = post.likedUsers.filter({ $0.0 != currentUser.uid })
            if likedUsers.count > 0 {
                self.posts.append(post)
                
                likedUsers.forEach { id, username in
                    self.fetchUser(id: id)
                }
            }
            
        }
                                         
            self.posts = self.posts.uniqued()
            self.users = self.users.uniqued()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            print(self.posts)
            

        })
    }
    
    var users = [User]()

    func fetchUser(id: String) {
   
    Database.database().reference().child("users").child("\(id)").observeSingleEvent(of: .value, with: { snapshot in
        guard let dictionary = snapshot.value as? [String: Any] else {return}
        
        self.users.append(User(uid: id, dictionary: dictionary))
        DispatchQueue.main.async {
            self.collectionView.reloadData() 
        }
    })
}
}
