//
//  ProfileLikeCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 11.02.2024.
//

import UIKit
import SnapKit

class ProfileLikeCell: UICollectionViewCell{
    
//    lazy var likeView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .lightGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подписаться", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    lazy var postView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .lightGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    lazy var logo1ImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
//        imageView.backgroundColor = .white
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    lazy var likeLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Пользователь"
//        label.numberOfLines = 0
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    func setupLayouts() {
        
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(5)
            make.size.equalTo(50)
        }
        
        logoImageView.layer.cornerRadius = 25
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-90)
        }
        
        addSubview(followingButton)
        followingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(25)
            make.width.equalTo(80)
        }
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(50)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
import SwiftUI
@available(iOS 13.0, *)
struct ProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        let profileVC = ProfileLikeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) -> ProfileLikeViewController {
            return profileVC
        }
    }
}
*/
