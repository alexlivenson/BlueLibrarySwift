//
//  LibraryAPIProtocl.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 10/10/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation

@objc protocol LibraryAPIProtocol {
    func getAlbums() -> [Album]
    func addAlbum(album: Album, index: Int)
    func saveAlbums()
    func deleteAlbum(index: Int)
    func downloadImage(notification: NSNotification)
}