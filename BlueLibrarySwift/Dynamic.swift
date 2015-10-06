//
//  Listener.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/29/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = T -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}