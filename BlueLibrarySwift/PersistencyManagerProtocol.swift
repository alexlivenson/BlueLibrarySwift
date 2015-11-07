//
//  PersistencyManagerProtocol.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 11/6/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation
import UIKit

@objc protocol PersistencyManagerProtocol: AlbumResourceProtocol {
    func getImage(filename: String) -> UIImage?
    func saveImage(image: UIImage, filename: String)
}
