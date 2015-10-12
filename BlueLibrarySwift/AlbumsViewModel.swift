//
//  File.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 10/11/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation

class AlbumsViewModel {
    private var allAlbums = [Album]()
    private var currentAlbumData: (titles: [String], values: [String])?
    private var currentAlbumIndex = 0
    // We will use this array as a stick to push / pop operation for the undo option
    private var undoStack: [(Album, Int)] = []
    
    private let libraryAPI: LibraryAPIProtocol!
    
    init(libraryAPI: LibraryAPIProtocol) {
        self.libraryAPI = libraryAPI
        
        currentAlbumIndex = 0
        allAlbums = self.libraryAPI.getAlbums()
    }
    
    func getDataForAlbum(index: Int) {
        if index < allAlbums.count && index > -1 {
            let album = allAlbums[index]
            currentAlbumData = album.ae_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
    }
    
    func addAlbumAtIndex(album: Album, index: Int) {
        libraryAPI.addAlbum(album, index: index)
        currentAlbumIndex = index
    }
    
    func deleteAlbumAtCurrentIndex() {
        // 1
        let deleteAlbum = allAlbums[currentAlbumIndex]
        
        // 2
        let undoAction = (deleteAlbum, currentAlbumIndex)
        undoStack.append(undoAction)
        
        // 3
        libraryAPI.deleteAlbum(currentAlbumIndex)
    }
    
    func numberOfAlbums() -> Int {
        return allAlbums.count
    }
    
    func numberOfDataPoints() -> Int {
        if let rows = currentAlbumData?.titles.count {
            return rows
        }
        
        return 0
    }
    
}