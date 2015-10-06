//
//  HTTPClient.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit
import ReactiveCocoa

class HTTPClient: NSObject {

    func getRequest(url: String) -> AnyObject {
        return NSData()
    }
    
    func postRequest(url: String, body: String) -> AnyObject {
        return NSData()
    }
    
    // do reactive cocoa here?
    func downloadImage(url: String) -> UIImage? {
        guard let aUrl = NSURL(string: url) else {
            return nil
        }
        
        guard let data = NSData(contentsOfURL: aUrl) else {
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
//        return NSData(contentsOfURL: aUrl).flatMap() {
//            UIImage(data: $0)!
//        }
        
        return image
    }
    
}
