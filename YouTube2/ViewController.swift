//
//  ViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 07.01.2024.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let cellId = "cellId"
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchData()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
    }
    
    func fetchData() {
        ApiService.shared.fetchVideos { videos in
            self.videos = videos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    func setupCollectionView() {
        collectionView.register(VideoRowCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoRowCell
        cell.nameLabel.text = videos[indexPath.item].title
        cell.descLabel.text = videos[indexPath.item].channel?.name ?? "" + String(videos[indexPath.item].numberOfViews ?? 0)
        cell.videoBackgroundView.kf.setImage(with: URL(string: videos[indexPath.item].thumbnailImageName ?? ""))
        cell.logoImageView.kf.setImage(with: URL(string: videos[indexPath.item].channel?.profileImageName ?? ""))
        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    
}
