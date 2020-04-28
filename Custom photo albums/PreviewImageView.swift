//
//  PreviewImageView.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/28/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class PreviewImageView: UIImageView {
    
    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        backgroundColor = .clear
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
