//
//  PhotosController.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 4/27/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotosController: UIViewController {
    
    // MARK: Variables
    
    fileprivate enum BarButton: Int {
        case closeItem = 0
        case importItem = 1
    }
    
     var barButtons: [UIBarButtonItem] = []
    
    fileprivate var isFirstTime: Bool = true
    
    var albumsController: AlbumsController?
    var currentIndexPath: IndexPath?
    var fetchResult: PHFetchResult<PHAsset>!
    
    fileprivate var availableWidth: CGFloat = 0
    
    fileprivate var collectionViewFlowLayout = UICollectionViewFlowLayout()
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    // This is selected cell Index array
    fileprivate var selectedIndexes = [IndexPath]() {
        didSet {
            if selectedIndexes.count > 0 {
                setBarButton(BarButton.importItem)
            } else {
                setBarButton(BarButton.closeItem)
            }
        }
    }
    
    fileprivate var assets = [PHAsset]()
    
    // MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.allowsMultipleSelection = true   
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
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFirstTime = true
        
        createButButtons()
        
        setBarButton(BarButton.closeItem)
        
        resetCachedAssets()
        PHPhotoLibrary.shared().register(self)
        
        // Reaching this point without a segue means that this AssetGridViewController became visible at app launch. As such, match the behavior of the segue from the default "All Photos" view
        // FIXME: Not shure if it work
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var width: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            width = view.bounds.inset(by: view.safeAreaInsets).width
        } else {
            width = view.bounds.width
        }
        // Adjust the item size if the available width has changed.
        if availableWidth != width {
            availableWidth = width
            let columnCount = (availableWidth / 80).rounded(.towardZero)
            let itemLength = (availableWidth - columnCount - 1) / columnCount
            collectionViewFlowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager.
        if UIDevice.current.userInterfaceIdiom == .phone {
            thumbnailSize =  CGSize(width: 200, height: 200)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            thumbnailSize =  CGSize(width: 300, height: 300)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCachedAssets()
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Catch when back button tapped
        if isMovingFromParent {
            backBarButtonTapped()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstTime == true {
            isFirstTime = false
            
            // Auto scroll to last collectionView item
            collectionView.scrollToLast()
        }
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: Actions
    
    @objc fileprivate func closeBarButtonTapped(_ sender: UIBarButtonItem) {
        print("👆 CLOSE BAR BUTTON")
        
        albumsController?.assets = nil
        
        dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate func backBarButtonTapped() {
        print("👆 BACK BAR BUTTON")
        
        albumsController?.isEnteredFromApp = false
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: Constants.kUserDefaults.kPreviousIndexPath)
        userDefaults.synchronize()
        
    }
    
    @objc fileprivate func importBarButtonTapped(_ sender: UIBarButtonItem) {
        print("👆 IMPORT BAR BUTTON")
        
        if selectedIndexes.count > 0 {
            
            let dispatchGroup = DispatchGroup()
            for selectedIndex in selectedIndexes {
                // Enter the dispatch group
                dispatchGroup.enter()
                let asset = fetchResult.object(at: selectedIndex.item)
                assets.append(asset)
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                
                self.albumsController?.assets = self.assets
                                
                if let currentIndexPath = self.currentIndexPath {
                    self.storaIndexPath(currentIndexPath, byKey: Constants.kUserDefaults.kPreviousIndexPath)
                }
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
        } else {
            
            let alertControl = UIAlertController(title: NSLocalizedString("No selected images", comment: ""),
                                                 message: NSLocalizedString("Please select an image to import it.", comment: ""),
                                                 preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
            alertControl.addAction(defaultAction)
            present(alertControl, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: Helper
    
    fileprivate func createButButtons() {
        // Create Cancel button
        let closeBarButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain, target: self, action: #selector(closeBarButtonTapped(_:)))
        barButtons.append(closeBarButton)
        
        // Create Import button
        let importBarButton = UIBarButtonItem(title: NSLocalizedString("Import", comment: ""), style: .plain, target: self, action: #selector(importBarButtonTapped(_:)))
        barButtons.append(importBarButton)
    }
    
    fileprivate func setBarButton(_ item: BarButton) {
        
        navigationItem.rightBarButtonItem = barButtons[item.rawValue]
        
    }
    
    fileprivate func storaIndexPath(_ indexPath: IndexPath, byKey: String) {
        
        let indexPathData = NSKeyedArchiver.archivedData(withRootObject: indexPath)
        let userDefaults = UserDefaults.standard
        userDefaults.set(indexPathData, forKey: Constants.kUserDefaults.kPreviousIndexPath)
        userDefaults.synchronize()
        
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    // UpdateAssets
    fileprivate func updateCachedAssets() {
        
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The window you prepare ahead of time is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start and stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        // Store the computed rectangle for future comparison.
        previousPreheatRect = preheatRect
        
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
}

extension PhotosController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = fetchResult.object(at: indexPath.item)
        // Dequeue a GridViewCell.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { fatalError("Unexpected cell in collection view") }
        
        // Request an image for the asset from the PHCachingImageManager.
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // UIKit may have recycled this cell by the handler's activation time. Set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        // You need to check wether selected index array contain current index if yes then apply the overlay
        if selectedIndexes.contains(indexPath) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexes.append(indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectedIndexes = self.selectedIndexes.filter { $0 != indexPath}
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 12) / 3, height: (collectionView.bounds.width - 12) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
}

extension PhotosController: PHPhotoLibraryChangeObserver {
    
    // MARK: PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may originate from a background queue. As such, re-dispatch execution to the main queue before acting on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            // If we have incremental changes, animate them in the collection view.
            if changes.hasIncrementalChanges {
                // Handle removals, insertions, and moves in a batch update.
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                     to: IndexPath(item: toIndex, section: 0))
                    }
                })
                // We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                // Reload the collection view if incremental changes are not available.
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
}
