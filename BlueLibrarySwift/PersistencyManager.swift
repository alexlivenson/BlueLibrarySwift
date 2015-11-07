
//
//  PersistenyManager.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    private var albums = [Album]()
    private let albumDir = NSHomeDirectory() + "/Documents/"
    
    override init() {
        super.init()
        
        guard let data = NSData(contentsOfFile: albumDir + "albums.bin") else {
            createPlaceholderAlbum()
            return
        }
        
        let unarchivedAlbums = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Album]
        
        if let unwrappedAlbums = unarchivedAlbums {
            albums = unwrappedAlbums
        } else {
            createPlaceholderAlbum()
        }
    }
    
    private func createPlaceholderAlbum() {
        // NOTE: to allow http, need to configure plist with NSAllowsArbitraryLoads
        albums = [
            Album(title: "Best of Bowie",
                artist: "David Bowie",
                genre: "Pop",
                coverUrl: "http://www.progarchives.com/progressive_rock_discography_covers/3790/cover_2854141632010.jpg",
                year: "1992"),
            Album(title: "It's My Life",
                artist: "No Doubt",
                genre: "Pop",
                coverUrl: "https://upload.wikimedia.org/wikipedia/en/9/93/ItsMyLifeNoDoubtCover.jpg",
                year: "2003"),
            Album(title: "Nothing Like The Sun",
                artist: "Sting",
                genre: "Pop",
                coverUrl: "https://upload.wikimedia.org/wikipedia/en/3/30/%E2%80%A6Nothing_Like_the_Sun_(Sting_album_-_cover_art).jpg",
                year: "1999"),
            Album(title: "Staring at the Sun",
                artist: "U2",
                genre: "Pop",
                coverUrl: "http://media.u2.com/non_secure/images/20090218/discography/staring_at_the_sun2/600.jpg",
                year: "2000"),
            Album(title: "American Pie",
                artist: "Madonna",
                genre: "Pop",
                coverUrl: "http://www.billboard.com/files/styles/promo_650/public/media/madonna-american-pie-video-billboard-650.jpg",
                year: "2000")
        ]
        
        saveAlbums()
    }
    
}

extension PersistencyManager: PersistencyManagerProtocol {
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if albums.count >= index {
            albums.insert(album, atIndex: index)
        } else {
            albums.append(album)
        }
    }
    
    func saveAlbums() {
        let filename = albumDir + "albums.bin"
        let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
        data.writeToFile(filename, atomically: true)
    }
    
    func deleteAlbum(index: Int) {
        albums.removeAtIndex(index)
    }
    
    func getImage(filename: String) -> UIImage? {
        let path = albumDir + filename
        
        do {
            let data = try NSData(contentsOfFile: path, options: .UncachedRead)
            return UIImage(data: data)
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func saveImage(image: UIImage, filename: String) {
        let path = albumDir + filename
        let data = UIImagePNGRepresentation(image)
        data?.writeToFile(path, atomically: true)
    }
}
