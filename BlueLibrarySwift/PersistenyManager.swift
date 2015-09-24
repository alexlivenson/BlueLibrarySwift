
//
//  PersistenyManager.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit

class PersistenyManager: NSObject {
    private var albums = [Album]()
    
    override init() {
        albums = [
            Album(title: "Best of Bowie",
                artist: "David Bowie",
                genre: "Pop",
                coverUrl: "http://s3.amazonaws.com/CoverProject/album/album_david_bowie_pin_ups.png",
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
    }
    
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
    
    func deleteAlbumAtIndex(index: Int) {
        albums.removeAtIndex(index)
    }
    
    func saveImage(image: UIImage, filename: String) {

    }
    
    func getImage(filename: String) -> UIImage? {
        return nil
    }
}
