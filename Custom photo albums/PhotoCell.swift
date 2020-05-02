//
//  PhotoCell.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/27/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static var identifier: String = "PhotoCell"
    
    var representedAssetIdentifier: String!
    
    override var isSelected: Bool {
        didSet {

            if isSelected {
                overlayView.isHidden = false
            } else {
                overlayView.isHidden = true
            }

        }
    }
    
    var thumbnailImage: UIImage! {
        didSet {
            photoImageView.image = thumbnailImage
        }
    }
    
    var livePhotoBadgeImage: UIImage! {
        didSet {
            livePhotoBadgeImageView.image = livePhotoBadgeImage
        }
    }
    
    // MARK: Properties
    
    var photoImageView = PreviewImageView(frame: .zero)
    var livePhotoBadgeImageView = UIImageView(frame: .zero)
    
    var overlayView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var checkView = CheckView(frame: .zero)
    
    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        
        contentView.addSubview(livePhotoBadgeImageView)
        NSLayoutConstraint.activate([
            livePhotoBadgeImageView.widthAnchor.constraint(equalToConstant: 16),
            livePhotoBadgeImageView.heightAnchor.constraint(equalTo: livePhotoBadgeImageView.widthAnchor),
            livePhotoBadgeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            livePhotoBadgeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        photoImageView.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
        ])
        
        overlayView.addSubview(checkView)
        NSLayoutConstraint.activate([
            checkView.widthAnchor.constraint(equalToConstant: 24),
            checkView.heightAnchor.constraint(equalTo: checkView.widthAnchor),
            checkView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -4),
            checkView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -4)
        ])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        livePhotoBadgeImageView.image = nil
        
    }
    
}
