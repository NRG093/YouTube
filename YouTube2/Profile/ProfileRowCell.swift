//
//  ProfileRowCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 04.02.2024.
//

import UIKit
import SnapKit

class ProfileRowCell: UICollectionViewCell{
    
    lazy var loginView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "list")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var profileView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(_colorLiteralRed: 255, green: 255, blue: 0, alpha: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")?.withRenderingMode(.alwaysOriginal)
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.text = "1,234\nPosts"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "5,678\nFollowers"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "9.101\nFollowing"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dataView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Username\n
        Category/Genre text
        ☺️ Я Дима Степанов
        ☺️ Делаю дизайн, который работает
        ☺️ Делюсь фишками в ленте
        ☺️ Выполняю задачи любой сложности
        """
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tabbarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit profile", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    
//    lazy var postsButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "Icons (1)")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
//    lazy var playButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "Icons (2)")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
//    lazy var marksButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "Icons (3)")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    func setupLayouts() {
        addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        loginView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loginView.addSubview(logOutButton)
        logOutButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        profileView.addSubview(avaImageView)
        avaImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(90)
        }
        
        avaImageView.layer.cornerRadius = 45
        
        let profileLabelStackView = UIStackView(arrangedSubviews: [postsLabel, 
                                                                   followersLabel,
                                                                   followingLabel])
        profileLabelStackView.axis = .horizontal
        profileLabelStackView.spacing = 20
        profileLabelStackView.distribution = .fillEqually
        
        profileView.addSubview(profileLabelStackView)
        profileLabelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(avaImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
//        profileView.addSubview(postsLabel)
//        postsLabel.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(avaImageView.snp.right).offset(60)
//        }
//        
//        profileView.addSubview(followersLabel)
//        followersLabel.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(postsLabel.snp.right).offset(24)
//        }
//        
//        profileView.addSubview(followingLabel)
//        followingLabel.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.left.equalTo(followersLabel.snp.right).offset(24)
//        }
        
        addSubview(dataView)
        dataView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        dataView.addSubview(dataLabel)
        dataLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        addSubview(tabbarView)
        tabbarView.snp.makeConstraints { make in
            make.top.equalTo(dataView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        tabbarView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        }
        
//        tabbarView.addSubview(postsButton)
//        postsButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(13)
//            make.left.equalToSuperview().offset(53)
//        }
//        
//        tabbarView.addSubview(playButton)
//        playButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(13)
//            make.left.equalTo(postsButton.snp.right).offset(106)
//        }
//        
//        tabbarView.addSubview(marksButton)
//        marksButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(13)
//            make.left.equalTo(playButton.snp.right).offset(106)
//        }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileRowCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProfileCell
        cell.backgroundColor = .brown
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
}

