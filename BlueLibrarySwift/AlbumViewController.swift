//
//  ViewController.swift
//  BlueLibrarySwift
//
//  Created by alex livenson on 9/23/15.
//  Copyright © 2015 alex livenson. All rights reserved.
//

import UIKit
import ReactiveCocoa

class AlbumViewController: UIViewController {

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var scroller: HorizontalScroller!
    
    // NOTE: Reactive Cocoa does not yet have good support for UIBarButtonItems
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    // To be injection by DI Frameworkx
    var notificationCenter: NSNotificationCenter!
    var albumsViewModel: AlbumsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        undoButton.rac_command = RACCommand(signalBlock: { (barButton: AnyObject!) -> RACSignal! in
            self.albumsViewModel.undoAction()
            self.reloadScroller()
            
            if self.albumsViewModel.numberOfAlbumsDeleted == 0 {
                self.undoButton.enabled = false
            }
            
            self.deleteButton.enabled = true
            
            return RACSignal.empty()
        })
        
        deleteButton.rac_command = RACCommand(signalBlock: { (barButton: AnyObject!) -> RACSignal! in
            self.albumsViewModel.deleteAlbum()
            self.reloadScroller()
            self.undoButton?.enabled = true
            
            if self.albumsViewModel.numberOfAlbums == 0 {
                self.deleteButton.enabled = false
            }

            return RACSignal.empty()
        })
        
        // 1
        self.navigationController?.navigationBar.translucent = false
        
        // 3
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
        view.addSubview(dataTable)        
        
        scroller.delegate = self
        reloadScroller()
        styleToolbarButtons()
        
        notificationCenter.addObserver(self,
            selector: "saveCurrentState",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func styleToolbarButtons() {
        if albumsViewModel.numberOfAlbums == 0 {
            deleteButton.enabled = false
        }
        
        if albumsViewModel.numberOfAlbumsDeleted == 0 {
            undoButton.enabled = false
        }
    }
    
    func reloadScroller() {
        self.albumsViewModel.reload()
        scroller.reload()
        dataTable.reloadData()
    }
    
    // MARK: Memento Pattern
    func saveCurrentState() {
        albumsViewModel.saveCurrentState()
    }
    
    func addAlbumAtIndex(album: Album, index: Int) {
        albumsViewModel.addAlbumAtIndex(album, index: index)
        reloadScroller()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsViewModel.numberOfDataPoints
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        if let albumData = albumsViewModel.albumDataForCurrentIndex {
            cell.textLabel?.text = albumData.titles[indexPath.row]
            cell.detailTextLabel?.text = albumData.values[indexPath.row]
        }
        
        return cell
    }
}

extension AlbumViewController: UITableViewDelegate {
    
}

extension AlbumViewController: HorizontalScrollerDelegate {
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        
        let previousAlbumView = scroller.viewAtIndex(albumsViewModel.currentIndex) as! AlbumView
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        
        previousAlbumView.highlightAlbum(false)
        albumView.highlightAlbum(true)
        albumsViewModel.currentIndex = index
        
        dataTable.reloadData()
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return albumsViewModel.numberOfAlbums
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView {
        let album = albumsViewModel.album(index)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let albumView = AlbumView(frame: frame, albumCover: album.coverUrl, notificationCenter: notificationCenter)
        
        if albumsViewModel.currentIndex == index {
            albumView.highlightAlbum(true)
        } else {
            albumView.highlightAlbum(false)
        }
        
        return albumView
    }
    
    func initialViewIndex(scroller: HorizontalScroller) -> Int {
        return albumsViewModel.currentIndex
    }
}

