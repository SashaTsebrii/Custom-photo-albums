//
//  AddController.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 5/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import Photos

class AddController: UIViewController {
    
    // MARK: Variables
    
    let userDefaults = UserDefaults.standard
    var selectedImages = [UIImage]()
    
    // MARK: Properties
    
    let addButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Design.background
        
        title = "Load"
        
        view.addSubview(addButton)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                addButton.widthAnchor.constraint(equalToConstant: 64),
                addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
                addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 64.0).isActive = true
            NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: addButton, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: addButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: addButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.0, constant: -16.0).isActive = true
        }
        
        view.addSubview(previewImageView)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                previewImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                previewImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                previewImageView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint(item: previewImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .notAnAttribute, multiplier: 1.0, constant: 16.0).isActive = true
            NSLayoutConstraint(item: previewImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 16.0).isActive = true
            NSLayoutConstraint(item: previewImageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 0.0, constant: -16.0).isActive = true
            NSLayoutConstraint(item: previewImageView, attribute: .bottom, relatedBy: .equal, toItem: addButton, attribute: .top, multiplier: 0.0, constant: -16.0).isActive = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kStringUrls)
        userDefaults.synchronize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let stringUrls = userDefaults.array(forKey: Constants.kUserDefaults.kStringUrls) {
            print(stringUrls)
            
            if stringUrls.count > 0 {
                for stringUrl in stringUrls as! [String] {
                    let correctStringUrl = "file://" + stringUrl
                    guard let url = URL(string: correctStringUrl) else { return }
                    do {
                        let imageData = try Data(contentsOf: url)
                        previewImageView.image = UIImage(data: imageData)
                    } catch {
                        print("Error loading image : \(error)")
                    }
                }
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kStringUrls)
        userDefaults.synchronize()
        
    }
    
    // MARK: Actions
    
    @objc func addButtonTapped(_ sender: UIButton) {
        print("👆 ADD BAR BUTTON")
        
        let albumsController = AlbumsController()
        navigationController?.pushViewController(albumsController, animated: true)
    }
    
}
