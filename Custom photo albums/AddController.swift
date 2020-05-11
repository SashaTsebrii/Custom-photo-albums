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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Actions
    
    @objc func addButtonTapped(_ sender: UIButton) {
        print("👆 ADD BAR BUTTON")
        
        let albumsController = AlbumsController()
        albumsController.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.pushViewController(albumsController, animated: true)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.pushViewController(albumsController, animated: true)
            // TODO:
            /*
            navigationController?.modalPresentationStyle = .custom
            navigationController?.present(UINavigationController(rootViewController: albumsController), animated: true, completion: nil)
            */
        }
        
    }
    
}

extension AddController: AlbumsControllerDelegate {
    
    // MARK: AlbumsControllerDelegate
    
    func getPhoto(urlStrings: [String]?) {
        if let urlStrings = urlStrings {
            for urlString in urlStrings {
                let correctStringUrl = "file://" + urlString
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
