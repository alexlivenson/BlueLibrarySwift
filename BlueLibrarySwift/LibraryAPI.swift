//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit
import ReactiveCocoa

// Library API will be exposed to other code but will hide HTTPClient and PersistencyManager (Facade Pattern)
class LibraryAPI: NSObject {
    private let persistencyManager: PersistencyManagerProtocol
    private let httpClient: HTTPClient
    private let notificationCenter: NSNotificationCenter
    private var isOnline: Bool
    
    init(persistencyManager: PersistencyManagerProtocol, httpClient: HTTPClient, notificationCenter: NSNotificationCenter) {
        self.persistencyManager = persistencyManager
        self.httpClient = httpClient
        self.notificationCenter = notificationCenter
        self.isOnline = false
        
        super.init()
        registerObservers()
    }
    
    
    func registerObservers() {
        notificationCenter.addObserver(self,
            selector: "downloadImage:",
            name: "BLDownloadImageNotification",
            object: nil)
    }
    
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}

extension LibraryAPI: LibraryAPIProtocol {
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
        persistencyManager.deleteAlbum(index)
        
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    func downloadImage(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let imageView = userInfo["imageView"] as? UIImageView,
            let coverUrl = userInfo["coverUrl"] as? String,
            let lastPathComponent  = NSURL(fileURLWithPath: coverUrl).lastPathComponent else {
                return
        }
        
        imageView.image = persistencyManager.getImage(lastPathComponent)
        
        if imageView.image != nil {
            return
        }
        
        httpClient.signalForLoadingImage(coverUrl)
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { (image: AnyObject!) -> Void in
                if let image = image as? UIImage {
                    imageView.image = image
                    self.persistencyManager.saveImage(image, filename: lastPathComponent)
                }
        }
    }
}
