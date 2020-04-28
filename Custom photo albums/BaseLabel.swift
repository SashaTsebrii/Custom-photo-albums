//
//  BaseLabel.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/28/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
        
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = .black
        textAlignment = .left
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
