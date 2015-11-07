//
//  File.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 10/11/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation

class AlbumsViewModel: NSObject {
    private var userDefaults: NSUserDefaults!
    private var allAlbums = [Album]()
    private var currentAlbumData: (titles: [String], values: [String])?
    private var currentAlbumIndex = 0
    // We will use this array as a push / pop operation for the undo option
    private var undoStack: [(Album, Int)] = []
    
    private let libraryAPI: LibraryAPIProtocol!
    
    var numberOfAlbums: Int {
        return allAlbums.count
    }
    
    var numberOfAlbumsDeleted: Int {
        return undoStack.count
    }
    
    var numberOfDataPoints: Int {
        currentAlbumData = getDataForAlbum(currentAlbumIndex)
        
        if let rows = currentAlbumData?.titles.count {
            return rows
        }
        
        return 0
    }
    
    var currentIndex: Int {
        get {
            return currentAlbumIndex
        }
        set {
            currentAlbumIndex = newValue
        }
    }
    
    var albumDataForCurrentIndex: (titles: [String], values: [String])? {
        return getDataForAlbum(currentAlbumIndex)
    }
    
    init(libraryAPI: LibraryAPIProtocol, userDefaults: NSUserDefaults) {
        self.libraryAPI = libraryAPI
        self.userDefaults = userDefaults
        
        allAlbums = self.libraryAPI.getAlbums()
        currentAlbumIndex = userDefaults.integerForKey("currentAlbumIndex")
    }
    
    func reload() {
        allAlbums = self.libraryAPI.getAlbums()
    }
    
    func getDataForAlbum(index: Int) -> (titles: [String], values: [String])? {
        if index < allAlbums.count && index > -1 {
            let album = allAlbums[index]
            currentAlbumData = album.ae_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
        
        return currentAlbumData
    }

    func album(index: Int) -> Album {
        return allAlbums[index]
    }
    
    func addAlbumAtIndex(album: Album, index: Int) {
        libraryAPI.addAlbum(album, index: index)
        currentAlbumIndex = index
    }
    
    func deleteAlbumAtCurrentIndex() {
        let deleteAlbum = allAlbums[currentAlbumIndex]
        let undoAction = (deleteAlbum, currentAlbumIndex)
        
        undoStack.append(undoAction)
        libraryAPI.deleteAlbum(currentAlbumIndex)
    }
    
    func undoAction() {
        if undoStack.count > 0 {
            let (deletedAlbum, index) = undoStack.popLast()!
            addAlbumAtIndex(deletedAlbum, index: index)
        }
    }
            
    func saveCurrentState() {
        userDefaults.setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
    }
    
}