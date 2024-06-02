//
//  SearchRowCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 28.01.2024.
//

import UIKit
import SnapKit

class SearchRowCell: UICollectionViewCell{
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 1
        label.textColor = .black
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
            make.top.left.bottom.equalToSuperview().inset(5)
            make.size.equalTo(50)
        }
        
        logoImageView.layer.cornerRadius = 25
        
        addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(5)
            make.left.equalTo(logoImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
