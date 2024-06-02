//
//  MainTabBarController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 11.02.2024.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            let navController = UINavigationController(rootViewController: loginViewController)
            self.present(navController, animated: true)
        }
        
        viewControllers = [
            templateNavController(unselectedImage: "home_unselected", selectedImage: "home_selected", rootViewController: FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())),
            templateNavController(unselectedImage: "search_unselected", selectedImage: "search_selected", rootViewController: SearchViewController(collectionViewLayout: UICollectionViewFlowLayout())),
            templateNavController(unselectedImage: "plus_unselected", selectedImage: "plus_selected", rootViewController: AddPostViewController()),
            templateNavController(unselectedImage: "like_unselected", selectedImage: "like_selected", rootViewController: ProfileLikeViewController(collectionViewLayout: UICollectionViewFlowLayout())),
            templateNavController(unselectedImage: "profile_unselected", selectedImage: "profile_selected", rootViewController: ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        ]
        
        tabBar.tintColor = .black
        
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }

    func templateNavController(unselectedImage: String, selectedImage: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: unselectedImage)?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        
        return navController
    }
}
