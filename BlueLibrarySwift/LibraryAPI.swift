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
    private let persistencyManager: PersistencyManager
    private let httpClient: HTTPClient
    private let notificationCenter: NSNotificationCenter
    private var isOnline: Bool
        
    init(persistencyManager: PersistencyManager, httpClient: HTTPClient, notificationCenter: NSNotificationCenter) {
        self.persistencyManager = persistencyManager
        self.httpClient = httpClient
        self.notificationCenter = notificationCenter
        self.isOnline = false
        
        super.init()
        registerObservers()
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
            
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    func deleteAlbum(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    func registerObservers() {
        notificationCenter.addObserver(self,
            selector: "downloadImage:",
            name: "BLDownloadImageNotification",
            object: nil)
    }
    
    func downloadImage(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject] else  {
            return
        }
        
        guard let imageView = userInfo["imageView"] as? UIImageView else {
            return
        }
        
        guard let coverUrl = userInfo["coverUrl"] as? String else {
            return
        }
        
        guard let lastPathComponent = NSURL(fileURLWithPath: coverUrl).lastPathComponent else {
            return
        }
        
        imageView.image = persistencyManager.getImage(lastPathComponent)
        
        if imageView.image == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                let downloadedImage = self.httpClient.downloadImage(coverUrl)
                
                dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                    imageView.image = downloadedImage
                    
                    if let _downloadedImage = downloadedImage {
                        self.persistencyManager.saveImage(_downloadedImage, filename: lastPathComponent)
                    }
                }
            }
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
