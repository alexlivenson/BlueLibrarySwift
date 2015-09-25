//
//  AlbumView.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    private var coverImage: UIImageView!
    private var indicator: UIActivityIndicatorView!
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    private let imageKeyPath = "image"
    
    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        commonInit()
        
        notificationCenter.postNotificationName(
            "BLDownloadImageNotification",
            object: self,
            userInfo: ["imageView": coverImage, "coverUrl": albumCover])
        
    }
    
    // NOTE: Required because UIView conforms to NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.blackColor()
        coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(coverImage)
        
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
        
        // KVO -> Should come before notification center
        coverImage.addObserver(self,
            forKeyPath: imageKeyPath,
            options: .Prior,
            context: nil)
    }
    
    func highlightAlbum(didHighlightView: Bool) {
        if didHighlightView {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == imageKeyPath {
            indicator.stopAnimating()
        }
    }
    
    deinit {
        coverImage.removeObserver(self, forKeyPath: imageKeyPath)
    }

}
