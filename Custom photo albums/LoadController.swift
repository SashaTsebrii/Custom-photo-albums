//
//  LoadController.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 5/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import Photos

class LoadController: UIViewController {
    
    // MARK: Variables
    
    
    
    // MARK: Properties
    
    let importButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.addTarget(self, action: #selector(importButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Design.background
        
        title = "Load"
        
        view.addSubview(importButton)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                importButton.widthAnchor.constraint(equalToConstant: 64),
                importButton.heightAnchor.constraint(equalTo: importButton.widthAnchor),
                importButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                importButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint(item: importButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0).isActive = true
            NSLayoutConstraint(item: importButton, attribute: .height, relatedBy: .equal, toItem: importButton, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: importButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: importButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.0, constant: -16.0).isActive = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // MARK: Actions
    
    @objc func importButtonTapped(_ sender: UIButton) {
        let albumsController = AlbumsController()
        navigationController?.pushViewController(albumsController, animated: true)
    }
    
}
