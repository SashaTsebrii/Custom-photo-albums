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
    
    fileprivate var selectedImages = [UIImage]()
    
    fileprivate var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: previewImageView.bounds.width * scale, height: previewImageView.bounds.height * scale)
    }
    
    // MARK: Properties
    
    fileprivate let addButton: CircleButton = {
        let button = CircleButton(frame: .zero)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate let previewImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Design.background
        
        title = "Add"
        
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
        
        previewImageView.addSubview(activityView)
        if #available(iOS 9, *) {
            NSLayoutConstraint.activate([
                activityView.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
                activityView.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint(item: activityView, attribute: .centerX, relatedBy: .equal, toItem: previewImageView, attribute: .centerX, multiplier: 1.0, constant: 1.0).isActive = true
            NSLayoutConstraint(item: activityView, attribute: .centerY, relatedBy: .equal, toItem: previewImageView, attribute: .centerY, multiplier: 1.0, constant: 1.0).isActive = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askAccessToPhotoLibrary()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func addButtonTapped(_ sender: UIButton) {
        print("👆 ADD BUTTON")
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            
            let albumsController = AlbumsController()
            albumsController.isEnteredFromApp = true
            albumsController.delegate = self
            let navigationController = UINavigationController(rootViewController: albumsController)
            if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                navigationController.modalPresentationStyle = .formSheet
                self.present(navigationController, animated: true, completion: nil)
                var size: CGSize = .zero
                if UIDevice.current.orientation.isPortrait {
                    print("🔄 Portrait")
                    size = CGSize(width: view.bounds.width * 0.7, height: view.bounds.height * 0.7)
                } else if UIDevice.current.orientation.isLandscape {
                    print("🔄 Landscape")
                    size = CGSize(width: view.bounds.height * 0.7, height: view.bounds.width * 0.7)
                }
                navigationController.preferredContentSize = size
            }
            
        } else {
            
            let alertController = UIAlertController(title: "No access to Photo Albums", message: "Please, allow the application to access Photo Albums. You can do this by going to Settings -> CustomPhotoAlbum -> Photos.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            if #available(iOS 10.0, *) {
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                    
                }
                alertController.addAction(settingsAction)
                
            }
            
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: Helper
    
    fileprivate func askAccessToPhotoLibrary() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            
            let alertControl = UIAlertController(title: "Need access to Photo Albums", message: "Please, allow the application to access Photo Albums. Otherwise, you will not be able to use all the functionality of this application.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                PHPhotoLibrary.requestAuthorization( {status in
                    if status == .authorized {
                        
                    } else {
                        
                    }
                })
            }
            alertControl.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertControl.addAction(cancelAction)
            present(alertControl, animated: true, completion: nil)
            
        }
        
    }
    
}

extension AddController: AlbumsControllerDelegate {
    
    // MARK: AlbumsControllerDelegate
    
    func getPhoto(assets: [PHAsset]?) {
        
        if let assets = assets {
            for asset in assets {
                
                if !activityView.isAnimating {
                    activityView.startAnimating()
                }
                
                // Prepare the options to pass when fetching the (photo, or video preview) image.
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isNetworkAccessAllowed = true
                
                PHImageManager.default().requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: options, resultHandler: { image, _ in
                    
                    // If the request succeeded, show the image view.
                    guard let image = image else { return }
                    
                    // Show the image.
                    self.previewImageView.image = image
                    
                    DispatchQueue.main.async {
                        if self.activityView.isAnimating {
                            self.activityView.stopAnimating()
                        }
                    }
                    
                })
            }
        }
        
    }
    
}
