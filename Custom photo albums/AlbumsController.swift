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
    
    var allAlbums = [Album]()
    
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
        
        // Create a PHFetchResult object for each section in the collection view. Fetching all PHAssetCollections with at least some media in it
        
        // Create and set all photos
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let allPhotos: PHFetchResult<PHAsset>! = PHAsset.fetchAssets(with: allPhotosOptions)
        let allPhotosAlbum = Album(name: "All Photos", fetchResult: allPhotos)
        allAlbums.append(allPhotosAlbum)
        
        // Create user collection
        var userCollections: PHFetchResult<PHCollection>!
        let userCollectionOptions = PHFetchOptions()
        userCollectionOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: userCollectionOptions)
        
        let smartAlbumsOptions = PHFetchOptions()
        // TODO: Try sort objects for evry smart album
        /*
        smartAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        smartAlbumsOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        */
        
        // Create and set favorites album
        let favoritesCollection: PHFetchResult<PHAssetCollection>! = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: smartAlbumsOptions)
        let favoritesCollectionFetchResult = PHAsset.fetchAssets(in: favoritesCollection.firstObject!, options: nil)
        let favoritesCollectionAlbum = Album(name: favoritesCollection.firstObject!.localizedTitle!, fetchResult: favoritesCollectionFetchResult)
        allAlbums.append(favoritesCollectionAlbum)
        
        // Create and set recently Added album
        let recentlyAddedCollection: PHFetchResult<PHAssetCollection>! = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: smartAlbumsOptions)
        let recentlyAddedCollectionFetchResult = PHAsset.fetchAssets(in: recentlyAddedCollection.firstObject!, options: nil)
        let recentlyAddedCollectionAlbum = Album(name: recentlyAddedCollection.firstObject!.localizedTitle!, fetchResult: recentlyAddedCollectionFetchResult)
        allAlbums.append(recentlyAddedCollectionAlbum)
        
        // Create and set self portraits album
        if #available(iOS 9, *) {
            let selfPortraitsCollection: PHFetchResult<PHAssetCollection>!
            selfPortraitsCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: smartAlbumsOptions)
            let selfPortraitsCollectionFetchResult = PHAsset.fetchAssets(in: selfPortraitsCollection.firstObject!, options: nil)
            let selfPortraitsCollectionAlbum = Album(name: selfPortraitsCollection.firstObject!.localizedTitle!, fetchResult: selfPortraitsCollectionFetchResult)
            allAlbums.append(selfPortraitsCollectionAlbum)
        }
        
        // Create and set screenshots album
        if #available(iOS 9, *) {
            let screenshotsCollection: PHFetchResult<PHAssetCollection>!
            screenshotsCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: smartAlbumsOptions)
            
            let screenshotsCollectionFetchResult = PHAsset.fetchAssets(in: screenshotsCollection.firstObject!, options: nil)
            let screenshotsCollectionAlbum = Album(name: screenshotsCollection.firstObject!.localizedTitle!, fetchResult: screenshotsCollectionFetchResult)
            allAlbums.append(screenshotsCollectionAlbum)
        }
        
        // Set user collections
        if userCollections.count > 0 {
            for index in 0...userCollections.count - 1 {
                let collection = userCollections.object(at: index)
                guard let userCollection = collection as? PHAssetCollection
                    else { fatalError("Expected an asset collection.") }
                let userCollectionFetchResult = PHAsset.fetchAssets(in: userCollection, options: nil)
                if userCollectionFetchResult.count > 0 {
                    let userCollectionAlbum = Album(name: collection.localizedTitle!, fetchResult: userCollectionFetchResult)
                    allAlbums.append(userCollectionAlbum)
                }
            }
        }
        
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
                
                let album = allAlbums[indexPath.row]
                photosController.title = album.name
                photosController.fetchResult = album.fetchResult
                
                navigationController?.pushViewController(photosController, animated: false)
                
            }
            
        }
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: Actons
    
    @objc fileprivate func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        print("👆 CANCEL BAR BUTTON")
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension AlbumsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as? AlbumCell else { fatalError("Unexpected cell in collection view") }
        
        let album = allAlbums[indexPath.row]
        cell.album = album
        
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photosController = PhotosController()
        photosController.albumsController = self
        
        let cell = collectionView.cellForItem(at: indexPath) as! AlbumCell
        let album = cell.album!
        
        photosController.title = album.name
        photosController.currentIndexPath = indexPath
        photosController.fetchResult = album.fetchResult
        
        navigationController?.pushViewController(photosController, animated: true)
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: Implement dynamic cell height
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: (collectionView.bounds.width * 0.5) - 16, height: (collectionView.bounds.width * 0.45) - 16)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (collectionView.bounds.width * 0.5) - 16, height: (collectionView.bounds.width * 0.4) - 16)
        } else {
            return .zero
        }
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
            /*
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                allPhotos = changeDetails.fetchResultAfterChanges
                // Don't update the table row that always reads "All Photos."
            }
            */
            
            // FIXME: Implement it for evry smart album
            // Update the cached fetch results, and reload the table sections to match.
            /*
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                collectionView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue))
            }
            */
            
            /*
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                collectionView.reloadSections(IndexSet(integer: Section.userCollections.rawValue))
            }
            */
        }
        
    }
    
}
