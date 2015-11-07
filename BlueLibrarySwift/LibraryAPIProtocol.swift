//
//  LibraryAPIProtocl.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 10/10/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation

@objc protocol LibraryAPIProtocol: AlbumResourceProtocol {
    func downloadImage(notification: NSNotification)
}