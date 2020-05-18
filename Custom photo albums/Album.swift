//
//  Album.swift
//  Custom photo albums
//
//  Created by Aleksandr Tsebrii on 5/18/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import Foundation
import Photos

struct Album {
    var name: String
    var fetchResult: PHFetchResult<PHAsset>
}
