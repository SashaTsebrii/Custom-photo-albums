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
    
    let userDefaults = UserDefaults.standard
    var selectedImages = [UIImage]()
    
    // MARK: Properties
    
    let importButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.addTarget(self, action: #selector(importButtonTapped(_:)), for: .touchUpInside)
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
        
        view.addSubview(previewImageView)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                previewImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                previewImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                previewImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                previewImageView.bottomAnchor.constraint(equalTo: importButton.topAnchor, constant: -16)
            ])
        } else {
            NSLayoutConstraint(item: previewImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .notAnAttribute, multiplier: 1.0, constant: 16.0).isActive = true
            NSLayoutConstraint(item: previewImageView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 16.0).isActive = true
            NSLayoutConstraint(item: previewImageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 0.0, constant: -16.0).isActive = true
            NSLayoutConstraint(item: previewImageView, attribute: .bottom, relatedBy: .equal, toItem: importButton, attribute: .top, multiplier: 0.0, constant: -16.0).isActive = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kSelectedIndexes)
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kAssetUrl)
        userDefaults.synchronize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexes = userDefaults.array(forKey: Constants.kUserDefaults.kSelectedIndexes) {
             print(indexes)
        }
        
        if let assetUrl = userDefaults.array(forKey: Constants.kUserDefaults.kAssetUrl) {
            print(assetUrl)
        }
        
//        for selectedIndex in selectedIndexes {
//            saveImageFromCell(byIndexPath: selectedIndex)
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kSelectedIndexes)
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kAssetUrl)
        userDefaults.synchronize()
        
    }
    
    // MARK: Actions
    
    @objc func importButtonTapped(_ sender: UIButton) {
        let albumsController = AlbumsController()
        navigationController?.pushViewController(albumsController, animated: true)
    }
    
    // MARK: Helper function
    
//    func saveImageFromCell(byIndexPath indexPath: IndexPath) {
//
//        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
//
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .highQualityFormat
//        options.isNetworkAccessAllowed = true
//        options.progressHandler = { progress, _, _, _ in
//        }
//
//        let scale = UIScreen.main.scale
//        let targetSize =  CGSize(width: cell.photoImageView.bounds.width * scale, height: cell.photoImageView.bounds.height * scale)
//
//        let asset = fetchResult.object(at: indexPath.item)
//
//        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options,
//                                              resultHandler: { image, _ in
//                                                // PhotoKit finished the request.
//
//                                                // If the request succeeded, show the image view.
//                                                guard let image = image else { return }
//
//                                                // Add selected index and image to selected arrays.
//                                                self.selectedImages.append(image)
//        })
//
//    }
    
}
