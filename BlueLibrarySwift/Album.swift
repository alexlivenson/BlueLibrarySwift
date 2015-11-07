//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

class Album: NSObject, NSCoding {
    
    private let title: String
    private let artist: String
    private let genre: String
    private let year: String
    let coverUrl: String
    
    override var description: String {
        return "title: \(title)" +
                "artist: \(artist)" +
                "genre: \(genre)" +
                "coverUrl: \(coverUrl)" +
                "year: \(year)"
    }
    
    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.artist = aDecoder.decodeObjectForKey("artist") as! String
        self.genre = aDecoder.decodeObjectForKey("genre") as! String
        self.year = aDecoder.decodeObjectForKey("year") as! String
        self.coverUrl = aDecoder.decodeObjectForKey("coverUrl") as! String
        
        super.init()
    }
    
    // Will be called when ask for Album to be archived
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(artist, forKey: "artist")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(year, forKey: "year")
        aCoder.encodeObject(coverUrl, forKey: "coverUrl")
    }
    
}

extension Album {
    // ae -> album extension
    func ae_tableRepresentation() -> (titles: [String], values: [String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}

