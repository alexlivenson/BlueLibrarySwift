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
    private let notificationCenter: NSNotificationCenter
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
        notificationCenter = NSNotificationCenter.defaultCenter()
        isOnline = false
        
        super.init()
        registerObservers()
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
    
    func saveAlbums() {
        persistenyManager.saveAlbums()        
    }
    
    func deleteAlbum(index: Int) {
        persistenyManager.deleteAlbumAtIndex(index)
        
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
        
        imageView.image = persistenyManager.getImage(lastPathComponent)
        
        if imageView.image == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                let downloadedImage = self.httpClient.downloadImage(coverUrl)
                
                dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                    imageView.image = downloadedImage
                    
                    if let _downloadedImage = downloadedImage {
                        self.persistenyManager.saveImage(_downloadedImage, filename: lastPathComponent)
                    }
                }
            }
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
