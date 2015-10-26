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
    var userDefaults: NSUserDefaults!
    var notificationCenter: NSNotificationCenter!
    var libraryAPI: LibraryAPIProtocol!
    var albumsViewModel: AlbumsViewModel!
    
    private var allAlbums = [Album]()
    private var currentAlbumData: (titles: [String], values: [String])?
    private var currentAlbumIndex = 0
    
    // We will use this array as a stick to push / pop operation for the undo option
    private var undoStack: [(Album, Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        undoButton.rac_command = RACCommand(signalBlock: { (barButton: AnyObject!) -> RACSignal! in
            self.albumsViewModel.undoAction()
            
            if self.albumsViewModel.numberOfAlbumsDeleted == 0 {
                (barButton as? UIBarButtonItem)?.enabled = false
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
        currentAlbumIndex = 0
        
        // 2
        allAlbums = libraryAPI.getAlbums()
        
        // 3
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
        view.addSubview(dataTable)
        
        loadPreviousState()
        
        scroller.delegate = self
        reloadScroller()
        
        showDataForAlbum(currentAlbumIndex)
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
        if allAlbums.count == 0 {
            deleteButton.enabled = false
        }
        
        if undoStack.count == 0 {
            undoButton.enabled = false
        }
    }

    func showDataForAlbum(albumIndex: Int) {
        if albumIndex < allAlbums.count && albumIndex > -1 {
            let album = allAlbums[albumIndex]
            currentAlbumData = album.ae_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
        
        dataTable.reloadData()
    }
    
    func reloadScroller() {
        self.albumsViewModel.reload()
        
//        allAlbums = libraryAPI.getAlbums()
//        if currentAlbumIndex < 0 {
//            currentAlbumIndex = 0
//        } else if currentAlbumIndex >= allAlbums.count {
//            currentAlbumIndex = allAlbums.count - 1
//        }
        
        scroller.reload()
        showDataForAlbum(currentAlbumIndex)
    }
    
    // MARK: Memento Pattern
    func saveCurrentState() {
        userDefaults.setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
    }
    
    func loadPreviousState() {
        currentAlbumIndex = userDefaults.integerForKey("currentAlbumIndex")
        showDataForAlbum(currentAlbumIndex)
    }
    
    func addAlbumAtIndex(album: Album, index: Int) {
//        libraryAPI.addAlbum(album, index: index)
//        currentAlbumIndex = index
        albumsViewModel.addAlbumAtIndex(album, index: index)
        reloadScroller()
    }
    
//    private func undoAction() {
//        // 1
//        if undoStack.count > 0 {
//            let (deletedAlbum, index) = undoStack.popLast()!
//            addAlbumAtIndex(deletedAlbum, index: index)
//        }
//        
//        // 2
//        if undoStack.count == 0 {
//            undoButton.enabled = false
//        }
//        
//        // 3
//        deleteButton.enabled = true
//    }
//    
//    private func deleteAlbum() {
//        // 1
//        let deleteAlbum = allAlbums[currentAlbumIndex]
//        
//        // 2
//        let undoAction = (deleteAlbum, currentAlbumIndex)
//        undoStack.append(undoAction)
//        
//        // 3
//        libraryAPI.deleteAlbum(currentAlbumIndex)
//        reloadScroller()
//        
//        // 4
//        undoButton?.enabled = true
//        
//        // 5
//        if allAlbums.count == 0 {
//            deleteButton.enabled = false
//        }
//
//    }
    
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
        
        if let albumData = currentAlbumData {
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
        let previousAlbumView = scroller.viewAtIndex(currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(false)
        
        currentAlbumIndex = index
        
        let albumView = scroller.viewAtIndex(index) as! AlbumView
        albumView.highlightAlbum(true)
        
        showDataForAlbum(index)
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return albumsViewModel.numberOfAlbums
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView {
        let album = allAlbums[index]
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let albumView = AlbumView(frame: frame, albumCover: album.coverUrl, notificationCenter: notificationCenter)
        
        if currentAlbumIndex == index {
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

