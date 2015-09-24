//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

// NOTE: Can also make this a struct
class Album: NSObject {
    
    private let title: String
    private let artist: String
    private let genre: String
    private let year: String
    let coverUrl: String
    
    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
        
        super.init()
    }

}

extension Album {
    // ae -> album extension
    func ae_tableRepresentation() -> (titles: [String], values: [String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}

