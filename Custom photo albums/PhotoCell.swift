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
    
    // MARK: Properties
    
    fileprivate var photoImageView = PreviewImageView(frame: .zero)
    
    fileprivate var overlayView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var checkView = CheckView(frame: .zero)
    
    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoImageView)
        if #available(iOS 9, *) {
            NSLayoutConstraint.activate([
                photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
                photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
                photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
                photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
            ])
        } else {
            NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 0.0, constant: 2.0).isActive = true
            NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 0.0, constant: 2.0).isActive = true
            NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 0.0, constant: -2.0).isActive = true
            NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 0.0, constant: -2.0).isActive = true
        }
        
        photoImageView.addSubview(overlayView)
        if #available(iOS 9, *) {
            NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: photoImageView.topAnchor),
                overlayView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
                overlayView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: photoImageView, attribute: .top, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: photoImageView, attribute: .leading, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: overlayView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView, attribute: .trailing, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView, attribute: .bottom, multiplier: 0.0, constant: 0.0).isActive = true
        }
        
        overlayView.addSubview(checkView)
        if #available(iOS 9, *) {
            NSLayoutConstraint.activate([
                checkView.widthAnchor.constraint(equalToConstant: 24),
                checkView.heightAnchor.constraint(equalTo: checkView.widthAnchor),
                checkView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -4),
                checkView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -4)
            ])
        } else {
            NSLayoutConstraint(item: checkView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24.0).isActive = true
            NSLayoutConstraint(item: checkView, attribute: .height, relatedBy: .equal, toItem: checkView, attribute: .width, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: checkView, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: 0.0, constant: -4.0).isActive = true
            NSLayoutConstraint(item: checkView, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .bottom, multiplier: 0.0, constant: -4.0).isActive = true
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        
    }
    
}
