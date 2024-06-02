//
//  ProfileCell.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 04.02.2024.
//

import UIKit
import SnapKit

class ProfileCell: UICollectionViewCell{
    
    lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    func setupLayouts() {
        addSubview(contentImageView)
        contentImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(130)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
