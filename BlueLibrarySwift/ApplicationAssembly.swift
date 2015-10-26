//
//  ApplicationAssembly.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/27/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import Foundation
import Typhoon

class ApplicationAssembly: TyphoonAssembly {
    
    // MARK: - Bootstrapping
    
    var coreComponents: CoreComponents!
    
    dynamic func libraryAPI() -> AnyObject {
        return TyphoonDefinition.withClass(LibraryAPI.self) { (definition: TyphoonDefinition!) -> Void in
            definition.useInitializer("initWithPersistencyManager:httpClient:notificationCenter:") { (initializer: TyphoonMethod!) -> Void in
                initializer.injectParameterWith(self.coreComponents.persistencyManager())
                initializer.injectParameterWith(self.coreComponents.httpClient())
                initializer.injectParameterWith(NSNotificationCenter.defaultCenter())
            }
            
            definition.scope = .Singleton
        }
    }
    
    dynamic func albumsViewModel() -> AnyObject {
        return TyphoonDefinition.withClass(AlbumsViewModel.self) { (definition: TyphoonDefinition!) -> Void in
            
            definition.useInitializer("initWithLibraryAPI:") {
                (initializer: TyphoonMethod!) -> Void in
                initializer.injectParameterWith(self.libraryAPI())
            }
        }
    }
    
    
    // MARK: - Main Assembly
    
    dynamic func albumViewController() -> AnyObject {
        return TyphoonDefinition.withClass(AlbumViewController.self) { (definition: TyphoonDefinition!) -> Void in
            definition.injectProperty("libraryAPI", with: self.libraryAPI())
            definition.injectProperty("userDefaults", with: NSUserDefaults.standardUserDefaults())
            definition.injectProperty("notificationCenter", with: NSNotificationCenter.defaultCenter())
            definition.injectProperty("albumsViewModel", with: self.albumsViewModel())
        }
    }
}