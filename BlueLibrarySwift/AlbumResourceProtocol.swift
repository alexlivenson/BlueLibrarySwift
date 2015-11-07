//
//  AlbumResourceProtocol.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 11/6/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation

@objc protocol AlbumResourceProtocol {
    func getAlbums() -> [Album]
    func addAlbum(album: Album, index: Int)
    func saveAlbums()
    func deleteAlbum(index: Int)
}