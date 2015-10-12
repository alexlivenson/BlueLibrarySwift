//
//  CoreComponents.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/27/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation
import Typhoon

class CoreComponents: TyphoonAssembly {
    dynamic func httpClient() -> AnyObject {
        return TyphoonDefinition.withClass(HTTPClient.self)
    }
    
    dynamic func persistencyManager() -> AnyObject {
        return TyphoonDefinition.withClass(PersistencyManager.self)
    }
    
    
}