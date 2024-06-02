//
//  SearchViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 28.01.2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search users"
        searchController.definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        collectionView.backgroundColor = .white
        collectionView.register(SearchRowCell.self, forCellWithReuseIdentifier: "cellId")
        
        fetchUser()
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUser() {
        print("fetching users")
        
        let ref = Database.database().reference().child("users")
        ref.observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key,value) in
                
                if key == Auth.auth().currentUser?.uid {
                    print("found myself,omit from list")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else {return}
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for search:",err)
        }
                                     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SearchRowCell
        cell.loginLabel.text = filteredUsers[indexPath.item].username
        cell.logoImageView.kf.setImage(with: URL(string: filteredUsers[indexPath.item].profileImageUrl))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.user = filteredUsers[indexPath.item]
        vc.fromSearch = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    }

