//
//  AlbumCell.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/27/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import Photos

class AlbumCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static var identifier: String = "AlbumCell"
        
    var fetchResult: PHFetchResult<PHAsset>! {
        didSet {
            fetchPhotos()
        }
    }
    
    var images: [UIImage] = []
    
    // MARK: Properties

    var titleLabel: BaseLabel = {
        let label = BaseLabel(frame: .zero)
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        return label
    }()
    
    var subtitleLabel: BaseLabel = {
        let label = BaseLabel(frame: .zero)
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        } else {
            label.font = UIFont.systemFont(ofSize: 12)
        }
        return label
    }()
    
    var mainImageView = PreviewImageView(frame: .zero)
    var secondImageView = PreviewImageView(frame: .zero)
    var thirdImageView = PreviewImageView(frame: .zero)
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainImageView)
        if #available(iOS 9, *) {
            NSLayoutConstraint.activate([
                mainImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.62),
                mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
                mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
            ])
        } else {
            NSLayoutConstraint(item: mainImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: frame.width * 0.62).isActive = true
            NSLayoutConstraint(item: mainImageView, attribute: .height, relatedBy: .equal, toItem: mainImageView, attribute: .width, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: mainImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 0.0, constant: 4.0).isActive = true
            NSLayoutConstraint(item: mainImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 0.0, constant: 4.0).isActive = true
        }
        
        if #available(iOS 9, *) {
            let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            labelsStack.axis = .vertical
            labelsStack.distribution = .equalCentering
            labelsStack.alignment = .leading
            labelsStack.spacing = 4
            labelsStack.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(labelsStack)
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalToConstant: 16),
                subtitleLabel.heightAnchor.constraint(equalToConstant: 12),
                
                labelsStack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 4),
                labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
            ])
            
            let imagesStack = UIStackView(arrangedSubviews: [secondImageView, thirdImageView])
            imagesStack.axis = .vertical
            imagesStack.distribution = .fillEqually
            imagesStack.alignment = .fill
            imagesStack.spacing = 2
            imagesStack.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(imagesStack)
            NSLayoutConstraint.activate([
                imagesStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                imagesStack.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 2),
                imagesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                imagesStack.bottomAnchor.constraint(equalTo: labelsStack.topAnchor, constant: -4)
            ])
        } else {
            contentView.addSubview(secondImageView)
            NSLayoutConstraint(item: secondImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (mainImageView.bounds.height / 2) - 2).isActive = true
            NSLayoutConstraint(item: secondImageView, attribute: .top, relatedBy: .equal, toItem: mainImageView, attribute: .top, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: secondImageView, attribute: .leading, relatedBy: .equal, toItem: mainImageView, attribute: .trailing, multiplier: 0.0, constant: 2.0).isActive = true
            NSLayoutConstraint(item: secondImageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 0.0, constant: -4.0).isActive = true
            
            contentView.addSubview(thirdImageView)
            NSLayoutConstraint(item: thirdImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (mainImageView.bounds.height / 2) - 2).isActive = true
            NSLayoutConstraint(item: thirdImageView, attribute: .leading, relatedBy: .equal, toItem: mainImageView, attribute: .trailing, multiplier: 0.0, constant: 2.0).isActive = true
            NSLayoutConstraint(item: thirdImageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 0.0, constant: -4.0).isActive = true
            NSLayoutConstraint(item: thirdImageView, attribute: .bottom, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 0.0, constant: 0.0).isActive = true
            
            contentView.addSubview(titleLabel)
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 0.0, constant: 4.0).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 0.0, constant: 4.0).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 0.0, constant: -4.0).isActive = true
            
            contentView.addSubview(subtitleLabel)
            NSLayoutConstraint(item: subtitleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 0.0, constant: 4.0).isActive = true
            NSLayoutConstraint(item: subtitleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 0.0, constant: -4.0).isActive = true
            NSLayoutConstraint(item: subtitleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 0.0, constant: -4.0).isActive = true
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = nil
        secondImageView.image = nil
        thirdImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        
    }
    
    // MARK: Helper functions
    
    func fetchPhotos() {
        // Sort the images by descending creation date and fetch the first 3
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
//        if #available(iOS 9, *) {
//            fetchOptions.fetchLimit = 3
//        } else {
//            fetchOptions.fetchLimit = 3
//        }

        // Fetch the image assets
//        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // If the fetch result isn't empty, proceed with the image request
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 3 // <-- The number of images to fetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    // Repeatedly call the following method while incrementing the index until all the photos are fetched
    func fetchPhotoAtIndex(_ index: Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
        
        // Note that if the request is not set to synchronous the requestImageForAsset will return both the image and thumbnail; by setting synchronous to true it will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        // Perform the image request
        let targetSize =  CGSize(width: 100, height: 100)
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                // Add the returned image to your array
                self.images += [image]
            }
            // If you haven't already reached the first index of the fetch result and if you haven't already stored all of the images you need, perform the fetch request again with an incremented index
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                DispatchQueue.main.async {
                    if self.images.indices.contains(0) {
                        self.mainImageView.image = self.images[0]
                    }
                    if self.images.indices.contains(1) {
                        self.secondImageView.image = self.images[1]
                    }
                    if self.images.indices.contains(2) {
                        self.thirdImageView.image = self.images[2]
                    }
                }
                // Else you have completed creating your array
                print("Completed array: \(self.images)")
            }
        })
    }
    
}
