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
    
    var album: AlbumData? {
        didSet {
            backgroundColor = .lightGray
            
            titleLabel.text = album?.title
            if let items = album?.items {
                subtitleLabel.text = String(items)
            }
            mainImageView.backgroundColor = .red
            secondImageView.backgroundColor = .green
            thirdImageView.backgroundColor = .blue
        }
    }
    
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
            mainImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.7),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
        ])

        contentView.addSubview(secondImageView)
        NSLayoutConstraint.activate([
            secondImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.3),
            secondImageView.heightAnchor.constraint(equalTo: secondImageView.widthAnchor),
            secondImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            secondImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
        
        contentView.addSubview(thirdImageView)
        NSLayoutConstraint.activate([
            thirdImageView.widthAnchor.constraint(equalToConstant: frame.width * 0.3),
            thirdImageView.heightAnchor.constraint(equalTo: thirdImageView.widthAnchor),
            thirdImageView.topAnchor.constraint(equalTo: secondImageView.bottomAnchor, constant: 4),
            thirdImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 4),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
