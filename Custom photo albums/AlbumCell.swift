//
//  AlbumCell.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/27/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static var identifier: String = "AlbumCell"
    
    // MARK: Properties

    var titleLabel: BaseLabel = {
        let label = BaseLabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    var subtitleLabel: BaseLabel = {
        let label = BaseLabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    var mainImageView = PreviewImageView(frame: .zero)
    var secondImageView = PreviewImageView(frame: .zero)
    var thirdImageView = PreviewImageView(frame: .zero)
    
    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.62),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
        ])
        
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
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    f4
    
}
