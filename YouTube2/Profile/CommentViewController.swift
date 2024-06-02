//
//  CommentViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 31.03.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import SnapKit

class CommentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentUser: User?
    var post: Post?
    var comments = [Comment]()
    
    let cellId = "cellId"
    
    var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .red
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .send2), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllComments()
        setupLayouts()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(resource: .cancelShadow), style: .plain, target: self, action: #selector(handleCloseVC))
        
        mainCollectionView.backgroundColor = .white
        mainCollectionView.register(ProfileCommentCell.self, forCellWithReuseIdentifier: cellId)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        sendButton.addTarget(self, action: #selector(handleSendButtonPressed), for: .touchUpInside)
    }
    
    func setupLayouts() {
        
        view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        
        view.addSubview(commentView)
        commentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        commentView.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().offset(-70)
        }
        
        commentView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
    }
    
    @objc func handleCloseVC() {
        self.dismiss(animated: true)
    }
    
    @objc func handleSendButtonPressed() {
        guard let text = commentTextView.text, text.count > 0,
              let currentUser = currentUser,
              let postId = post?.id,
              let postOwnerId = post?.user?.uid
        else { return }
        
        let dataReference = Database.database().reference().child("posts").child(postOwnerId).child(postId).child("comments")
        
        dataReference.observeSingleEvent(of: .value) { snapshot in
            var dictionaryArray = snapshot.value as? Array<[String: Any]> ?? []
            
            var newDictionary = [String: Any]()
            newDictionary["user"] = currentUser.toDictionary()
            newDictionary["commentText"] = text
            if #available(iOS 15.0, *) {
                newDictionary["time"] = Date().formatted(date: .complete, time:  .standard)
                let comment = Comment(user: currentUser, dictionary: newDictionary)
                // Fallback on earlier versions
                
                dictionaryArray.append(newDictionary)
                
                dataReference.setValue(dictionaryArray)
                
                self.comments.append(comment)
                self.comments = self.comments.uniqued()
                
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                }
            }
        }
    }
    
    func fetchAllComments() {
        guard
            let postId = post?.id,
            let postOwnerId = post?.user?.uid
        else { return }
        
        let dataReference = Database.database().reference().child("posts").child(postOwnerId).child(postId).child("comments")
        
        dataReference.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaryArray = snapshot.value as? Array<[String: Any]> else { return }
            
            dictionaryArray.forEach { dict in
                let comment = Comment(user: nil, dictionary: dict)
                
                self.comments.append(comment)
            }
            
            self.comments = self.comments.uniqued()
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileCommentCell
        cell.logoImageView.kf.setImage(with: URL(string: comments[indexPath.item].user.profileImageUrl))
        cell.descriptionLabel.text = comments[indexPath.item].user.username
        cell.textLabel.text = comments[indexPath.item].commentText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let dummycell = ProfileCommentCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 3000))
        dummycell.descriptionLabel.text = comments[indexPath.item].user.username
        dummycell.textLabel.text = comments[indexPath.item].commentText
            dummycell.layoutIfNeeded()
            let estimatedSize = dummycell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 3000))
            return CGSize(width: collectionView.frame.width, height: estimatedSize.height)
    }
    
}
