//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

// Library API will be exposed to other code but will hide HTTPClient and PersistencyManager (Facade Pattern)
class LibraryAPI: NSObject {
    private let persistenyManager: PersistenyManager
    private let httpClient: HTTPClient
    private var isOnline: Bool
    
    class var sharedInstance: LibraryAPI {
        struct Singleton {
            static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }
    
    override init() {
        persistenyManager = PersistenyManager()
        httpClient = HTTPClient()
        isOnline = false
        
        super.init()
    }
    
    func getAlbums() -> [Album] {
        return persistenyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        persistenyManager.addAlbum(album, index: index)
            
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(index: Int) {
        persistenyManager.deleteAlbumAtIndex(index)
        
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
}
