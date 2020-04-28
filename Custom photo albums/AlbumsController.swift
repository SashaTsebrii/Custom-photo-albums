//
//  AlbumsController.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/25/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class AlbumsController: UIViewController {
    
    // MARK: Variables
    
    var albums: [AlbumData]?
    
    // MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Design.background
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Albums"
        
        // FIXME: Set albums.
        albums = [AlbumData(title: "First album", items: 10, photos: [PhotoData(image: UIImage()),
                                                                      PhotoData(image: UIImage())]),
                  AlbumData(title: "Second album", items: 100, photos: [PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage())]),
                  AlbumData(title: "Second album", items: 100, photos: [PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage()),
                                                                        PhotoData(image: UIImage())])]
        collectionView.reloadData()
        
    }
    
}

extension AlbumsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let albums = albums {
            return albums.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
        if let albums = albums {
            let album = albums[indexPath.item]
            cell.album = album
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photosController = PhotosController()
        if let albums = albums {
            let album = albums[indexPath.item]
            photosController.album = album
            navigationController?.pushViewController(photosController, animated: true)
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
