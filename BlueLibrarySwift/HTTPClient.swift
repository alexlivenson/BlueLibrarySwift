//
//  HTTPClient.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Alamofire

class HTTPClient: NSObject {

    func getRequest(url: String) -> AnyObject {
        return NSData()
    }
    
    func postRequest(url: String, body: String) -> AnyObject {
        return NSData()
    }
    
    func downloadImage(url: String) -> UIImage? {
        guard let aUrl = NSURL(string: url),
              let data = NSData(contentsOfURL: aUrl),
              let image = UIImage(data: data) else {
                
            return nil
        }
        
        
        return image
    }    
    
    func signalForLoadingImage(url: String) -> RACSignal {
        // execute on non main thread
        let schedular = RACScheduler(priority: RACSchedulerPriorityBackground)
        return RACSignal.createSignal { (subscriber: RACSubscriber!) -> RACDisposable! in
            
            guard let aUrl = NSURL(string: url),
                  let data = NSData(contentsOfURL: aUrl),
                  let image = UIImage(data: data) else {
                return nil
            }
            
            subscriber.sendNext(image)
            subscriber.sendCompleted()
            
            return nil
        }.subscribeOn(schedular)
    }
}
