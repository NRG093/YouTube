//
//  ProfileCommentCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 31.03.2024.
//

import UIKit
import SnapKit

class ProfileCommentCell: UICollectionViewCell{
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользователь"
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    func setupLayouts() {
        
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(5)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.size.equalTo(50)
        }
        
        logoImageView.layer.cornerRadius = 25
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-20)
        }
    }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
}

//import SwiftUI
//@available(iOS 13.0, *)
//struct ProfileVCProvider: PreviewProvider {
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//    
//    struct ContainerView: UIViewControllerRepresentable {
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//        
//        let profileVC = CommentViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileVCProvider.ContainerView>) -> CommentViewController {
//            return profileVC
//        }
//    }
//}
