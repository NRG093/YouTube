//
//  FeedCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 14.01.2024.
//

import UIKit
import SnapKit

protocol FeedCellDelegate {
    func didlike(post: Post)
    func didComment(post: Post)
}

class FeedCell: UICollectionViewCell{
    var post: Post?
    
    var delegate: FeedCellDelegate?
    
    var didRepostPressed: ((Post) -> (Void))?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Porsche"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var repostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "The Porsche 992 CT3 is probably one of the most desirable cars around"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
        setupButtonActions()
    }
    
    func setupButtonActions() {
        likeButton.addTarget(self, action: #selector(handleLikePressed), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(handleCommentPressed), for: .touchUpInside)
        repostButton.addTarget(self, action: #selector(handleRepostPressed), for: .touchUpInside)
    }
    
    @objc func handleLikePressed() {
        guard let post = post else { return }
        delegate?.didlike(post: post)
        }
    
    @objc func handleCommentPressed() {
        guard let post = post else { return }
        delegate?.didComment(post: post)
        }
        
    @objc func handleRepostPressed() {
        guard let post = post else { return }
        didRepostPressed?(post)
        }
            
    func setupLayouts() {
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.size.equalTo(30)
            
            logoImageView.layer.cornerRadius = 15
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.height.equalTo(30)
        }
        
        addSubview(contentImageView)
        contentImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(380)
        }
        
        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(50)
        }
        addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).offset(5)
            make.left.equalTo(likeButton.snp.right).offset(10)
            make.size.equalTo(50)
        }
        
        addSubview(repostButton)
        repostButton.snp.makeConstraints { make in
            make.top.equalTo(contentImageView.snp.bottom).offset(5)
            make.left.equalTo(commentButton.snp.right).offset(10)
            make.size.equalTo(50)
        }
        
        addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
