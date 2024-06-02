//
//  ProfileViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 04.02.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UICollectionViewController {
    
    let cellId = "cellId"
    let cellId1 = "cellid1"
    let padding: CGFloat = 1
    
    var fromSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !fromSearch {
            fetchUser()
        } else {
            fetchOrderedPosts()
        }
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(ProfileRowCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellId1)
    }
    
    var user: User?
    var posts = [Post]()
    var isFinishedPaging = false
    
    
    func paginatePosts() {
        guard let user = self.user else { return }
        let uid = user.uid
        let ref = Database.database().reference().child("posts").child(uid)
        
        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            allObjects.reverse()
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = UUID().uuidString
                
                self.posts.append(post)
            })
            
            self.posts = self.posts.sorted(by: { $0.creationDate > $1.creationDate }).uniqued()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }) { (err) in
            print("failed to paginate for posts:", err)
        }
    }
    
    private func fetchOrderedPosts(){
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        self.posts.removeAll()
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            guard let user = self.user else {return}
            let post = Post(user: user, dictionary: dictionary)
            
            self.posts.insert(post, at: 0)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    private func fetchUser() {
        guard let uid = (Auth.auth().currentUser?.uid) else { return }
        
        Database.database().reference().child("users").child("\(uid)").observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            self.user = User(uid: uid, dictionary: dictionary)
            
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
           
            self.fetchOrderedPosts()
        })
    }
}



extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileRowCell
            cell.logOutButton.addTarget(self, action: #selector(handleLogOutButton), for: .touchUpInside)
            cell.avaImageView.kf.setImage(with: URL(string: user?.profileImageUrl ?? ""))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! ProfileCell
            cell.backgroundColor = .systemBlue
            cell.contentImageView.kf.setImage(with: URL(string: self.posts[indexPath.item - 1].imageUrl))
            return cell
        }
    }
    
    @objc func handleLogOutButton() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("already logged out")
        }
        
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            let navController = UINavigationController(rootViewController: loginViewController)
            self.navigationController?.present(navController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            let dummycell = ProfileRowCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 3000))
            dummycell.layoutIfNeeded()
            let estimatedSize = dummycell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 3000))
            return CGSize(width: collectionView.frame.width, height: estimatedSize.height)
        }
        
        let itemWidth = collectionView.frame.width / 3 - padding
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
}
