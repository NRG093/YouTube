//
//  FeedViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 14.01.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var users = [User]()
    var posts = [Post]()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(resource: .camera3), style: .plain, target: self, action: #selector(handleSelectCamera))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .overFullScreen
            let navController = UINavigationController(rootViewController: loginViewController)
            self.navigationController?.present(navController, animated: true)
        }
        fetchUser()
    }
    
    @objc func handleSelectCamera() {
        let vc = CameraController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchUser() {
        users.removeAll()
        posts.removeAll()
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            for dictionary in dictionaries {
                let user = User(uid: dictionary.key, dictionary: dictionary.value as! [String: Any])
                
                if user.uid == Auth.auth().currentUser?.uid {
                    self.currentUser = user
                }
                
                self.users.append(user)
                
                self.fetchOrderedPosts(user: user)
            }
        })
    }
    
    private func fetchOrderedPosts(user: User){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            var post = Post(user: user, dictionary: dictionary)
            if post.id == nil {
                post.id = UUID().uuidString
            }
        
            if let hasLike = post.likedUsers[self.currentUser?.uid ?? ""] {
                post .hasLiked = true
            } else {
                post.hasLiked = false
            }
            
            self.posts.append(post)
            
            self.posts = self.posts.sorted(by: { $0.creationDate > $1.creationDate }).uniqued()
            
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    func setupCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        cell.post = posts[indexPath.item]
        cell.delegate = self
        
        cell.didRepostPressed = { [weak self] post in
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            self?.navigationController?.present(vc, animated: true)
        }
        cell.contentImageView.kf.setImage(with: URL(string: posts[indexPath.item].imageUrl))
        cell.descLabel.text = posts[indexPath.item].caption
        cell.nameLabel.text = posts[indexPath.item].user?.username
        cell.logoImageView.kf.setImage(with: URL(string: posts[indexPath.item].user?.profileImageUrl ?? ""))
        cell.likeButton.setImage(UIImage(resource: posts[indexPath.item].hasLiked ?.likeSelected : .likeUnselected), for: .normal)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 550)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.user = users[indexPath.item]
        vc.fromSearch = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: FeedCellDelegate {
    func didlike(post: Post) {
        print("didTapLike\(post.creationDate.timeIntervalSince1970)")
        guard let currentUser = currentUser,
              let postId = post.id
        else { return }
        guard let postOwnerId = post.user?.uid else { return }
//        let values: [String: Any] = ["postOwner": post.user.uid,
//                                     "like": !post.hasLiked,
//                                     "likedUser": currentUser.uid]
//        Database.database().reference().child("likes").child(postId).child(currentUser.uid).updateChildValues(values) { err, ref in
//            if let err = err {
//                print("Error to like Post", err)
//                return
//            }
//            
//            print("succes like post")
//            if let index = self.posts.firstIndex(where: { $0 == post}) {
//                self.posts[index].hasLiked = !post.hasLiked
//                DispatchQueue.main.async {
//                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
//                }
//            }
//        }
        let dataReference = Database.database().reference().child("posts").child(postOwnerId).child(postId).child("likedUsers")
        
        dataReference.observeSingleEvent(of: .value, with: { snapshot in
            
            var likedUsers = snapshot.value as? [String: String] ?? [:]
            
            var hasLiked = post.hasLiked
            
            if let value = likedUsers[currentUser.uid] {
                likedUsers.removeValue(forKey: currentUser.uid)
                hasLiked = false
            } else {
                likedUsers[currentUser.uid] = currentUser.username
                hasLiked = true
            }
            
            dataReference.setValue(likedUsers)
            
            if let postIndex = self.posts.firstIndex(where: { $0.id == postId } ) {
                self.posts[postIndex].hasLiked = hasLiked
                
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: [IndexPath(item: postIndex, section: 0)])
                }
            }
        })
    }
    
    func didComment(post: Post) {
        let vc = CommentViewController()
        vc.post = post
        vc.currentUser = currentUser
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(navVC, animated: true)
    }
}
