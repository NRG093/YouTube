//
//  VideoRowCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 07.01.2024.
//

import UIKit

class VideoRowCell: UICollectionViewCell{
    
    lazy var videoBackgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Маша и Медведь - Где же Мишка? Сборник лучших эпизодов"
        label.textColor = .black
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Маша и Медведь . 9,1 млн просмотров . 3 года назад"
        label.textColor = .lightText
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    func setupLayouts() {
        addSubview(videoBackgroundView)
        videoBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        videoBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        videoBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        videoBackgroundView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: videoBackgroundView.bottomAnchor, constant: 10).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: videoBackgroundView.bottomAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
        descLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 10).isActive = true
        descLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(separatorLine)
        separatorLine.topAnchor.constraint(greaterThanOrEqualTo: descLabel.bottomAnchor, constant: 5).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
