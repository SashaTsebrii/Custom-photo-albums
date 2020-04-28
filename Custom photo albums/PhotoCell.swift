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
    
    var photo: PhotoData? {
        didSet {
            photoImageView.image = photo?.image
            photoImageView.backgroundColor = .lightGray
        }
    }
    
    // MARK: Properties
    
    var photoImageView = PreviewImageView(frame: .zero)
    
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
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
