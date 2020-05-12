//
//  AlbumsController.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/25/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import Photos

protocol AlbumsControllerDelegate: class {
    func getPhoto(urlStrings: [String]?)
}

class AlbumsController: UIViewController {
    
    // MARK: Variables
    
    weak var delegate: AlbumsControllerDelegate?
    
    var isEnteredFromApp: Bool = false
    
    var urlStrings: [String]? {
        didSet {
            delegate?.getPhoto(urlStrings: urlStrings)
        }
    }
    
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
        
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    // MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.Design.background
        
        view.addSubview(collectionView)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 0.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.0, constant: 0.0).isActive = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Albums"
        
        // Create Cancel button
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped(_:)))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        // Create a PHFetchResult object for each section in the collection view.
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        let smartAlbumsOptions = PHFetchOptions()
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: smartAlbumsOptions)
        let userCollectionOptions = PHFetchOptions()

        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: userCollectionOptions)
        PHPhotoLibrary.shared().register(self)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isEnteredFromApp == true {
            
            if let indexPathData = UserDefaults.standard.object(forKey: Constants.kUserDefaults.kPreviousIndexPath) as? NSData {
                let indexPath = NSKeyedUnarchiver.unarchiveObject(with: indexPathData as Data) as! IndexPath
                
                let photosController = PhotosController()
                photosController.albumsController = self
                photosController.currentIndexPath = indexPath
                
                switch Section(rawValue: indexPath.section)! {
                case .allPhotos:
                    photosController.title = NSLocalizedString("All Photos", comment: "")
                    photosController.fetchResult = allPhotos
                case .smartAlbums:
                    let collection = smartAlbums.object(at: indexPath.row)
                    photosController.title = collection.localizedTitle
                    photosController.fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                case .userCollections:
                    let collection = userCollections.object(at: indexPath.row)
                    photosController.title = collection.localizedTitle
                    guard let assetCollection = collection as? PHAssetCollection
                        else { fatalError("Expected an asset collection.") }
                    photosController.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                }
                
                navigationController?.pushViewController(photosController, animated: true)
                
            }
            
        }
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: Actons
    
    @objc func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        print("👆 CANCEL BAR BUTTON")
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension AlbumsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos:
            return 1
        case .smartAlbums:
            return smartAlbums.count
        case .userCollections:
            return userCollections.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else { fatalError("Unexpected cell in collection view") }
        
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            cell.titleLabel.text = NSLocalizedString("All Photos", comment: "")
            cell.fetchResult = allPhotos
            return cell
        case .smartAlbums:
            let collection: PHCollection = smartAlbums.object(at: indexPath.row)
            cell.titleLabel.text = collection.localizedTitle
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("Expected an asset collection.") }
            cell.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            return cell
        case .userCollections:
            let collection: PHCollection = userCollections.object(at: indexPath.row)
            cell.titleLabel.text = collection.localizedTitle
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("Expected an asset collection.") }
            cell.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            return cell
        }
        
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photosController = PhotosController()
        photosController.albumsController = self
        
        let cell = collectionView.cellForItem(at: indexPath) as! AlbumCell
        photosController.title = cell.titleLabel.text
        
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            photosController.fetchResult = allPhotos
        case .smartAlbums:
            let indexPath = collectionView.indexPath(for: cell)!
            let collection: PHCollection = smartAlbums.object(at: indexPath.row)
            // Configure the view controller with the asset collection
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("Expected an asset collection.") }
            photosController.currentIndexPath = indexPath
            photosController.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        case .userCollections:
            let indexPath = collectionView.indexPath(for: cell)!
            let collection: PHCollection = userCollections.object(at: indexPath.row)
            // Configure the view controller with the asset collection
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("Expected an asset collection.") }
            photosController.currentIndexPath = indexPath
            photosController.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        }
        
        /*
        if indexPath.section == 0 {
            photosController.fetchResult = allPhotos
        } else {
            // Fetch the asset collection for the selected row.
            let indexPath = collectionView.indexPath(for: cell)!
            let collection: PHCollection
            
            switch Section(rawValue: indexPath.section)! {
            case .smartAlbums:
                collection = smartAlbums.object(at: indexPath.row)
            case .userCollections:
                collection = userCollections.object(at: indexPath.row)
            default:
                // The default indicates that other segues have already handled the photos section.
                return
            }
            
            // Configure the view controller with the asset collection
            guard let assetCollection = collection as? PHAssetCollection
                else { fatalError("Expected an asset collection.") }
            photosController.currentIndexPath = indexPath
            photosController.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        }
        */
        
        navigationController?.pushViewController(photosController, animated: true)
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width * 0.5) - 16, height: (collectionView.bounds.width * 0.45) - 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10) //.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension AlbumsController: PHPhotoLibraryChangeObserver {
    
    // MARK: PHPhotoLibraryChangeObserver
    
    // Respond to changes
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        // Change notifications may originate from a background queue. Re-dispatch to the main queue before acting on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                allPhotos = changeDetails.fetchResultAfterChanges
                // Don't update the table row that always reads "All Photos."
            }
            
            // Update the cached fetch results, and reload the table sections to match.
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                collectionView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue))
            }
            
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                collectionView.reloadSections(IndexSet(integer: Section.userCollections.rawValue))
            }
        }
        
    }
    
}
