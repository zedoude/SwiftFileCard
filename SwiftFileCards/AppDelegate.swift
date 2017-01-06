//
//  AppDelegate.swift
//  SwiftFileCards
//
//  Created by Cédric Ponchy on 05/01/17.
//  Copyright © 2017 Cédric Ponchy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPageControllerDelegate, NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var pageController : NSPageController!
    @IBOutlet weak var tableView : NSTableView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let dirURL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        // load all the file card URLs by enumerating through the user's Document folder
        self.pageController.delegate = self
        let enumerator = FileManager.default.enumerator(at: dirURL,
                                                        includingPropertiesForKeys: [.localizedNameKey,
                                                                                     .effectiveIconKey,
                                                                                     .isDirectoryKey,
                                                                                     .typeIdentifierKey,
                                                                                     .isRegularFileKey],
                                                        options: [.skipsHiddenFiles,
                                                                  .skipsPackageDescendants,
                                                                  .skipsSubdirectoryDescendants],
                                                        errorHandler: nil)!
        for case let u as URL in enumerator
        {
            guard let resourceValues = try? u.resourceValues(forKeys: [.localizedNameKey,
                                                                       .effectiveIconKey,
                                                                       .isDirectoryKey,
                                                                       .typeIdentifierKey,
                                                                       .isRegularFileKey])
                else {
                    continue
            }
            
            if resourceValues.isRegularFile == true {
                self.pageController.arrangedObjects.append(FileObject.fileObjectWithURL(url: u))
            }
        }
        
        // set the first card in our list
        if self.pageController.arrangedObjects.count > 0 {
            self.tableView.selectRowIndexes( IndexSet(integer: 0), byExtendingSelection: false)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func takeTransitionStyleFrom(_ sender: Any) {
        switch (sender as! NSButton).selectedTag() {
        case 0:
            self.pageController.transitionStyle = .stackHistory
        case 1:
            self.pageController.transitionStyle = .stackBook
        case 2:
            self.pageController.transitionStyle = .horizontalStrip
        default:
            self.pageController.transitionStyle = .stackHistory
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedIndex = self.tableView.selectedRow

        if (selectedIndex >= 0) && (selectedIndex != self.pageController.selectedIndex) {
            // The selection of the table view changed. We want to animate to the new selection.
            // However, since we are manually performing the animation,
            // -pageControllerDidEndLiveTransition: will not be called. We are required to
            // [self.pageController completeTransition] when the animation completes.
            //
            NSAnimationContext.runAnimationGroup({ (NSAnimationContext) in
                self.pageController.animator().selectedIndex = selectedIndex
            }, completionHandler: { 
                self.pageController.completeTransition()
            })
        }
    }
    
    // Required method for BookUI mode of NSPageController
    // We have different cards for image files and everything else.
    // Therefore, we have different identifiers
    //
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> String {
        let fileObj : FileObject = (object as! FileObject)
        if UTTypeConformsTo(fileObj.utiType as CFString, kUTTypeImage) {
            return "ImageCard"
        } else {
            return "FileCard"
        }
    }
    
    // Required method for BookUI mode of NSPageController
    //
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
        return NSViewController(nibName: identifier, bundle: nil)!
    }
    
    // Optional delegate method. This method is used to inset the card a little bit from it's parent view
    //
    func pageController(_ pageController: NSPageController, frameFor object: Any?) -> NSRect {
        return NSInsetRect(pageController.view.bounds, 5, 5)
    }

    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        // Update the NSTableView selection
        self.tableView.selectRowIndexes(IndexSet.init(integer: self.pageController.selectedIndex), byExtendingSelection: false)
        
        // tell page controller to complete the transition and display the updated file card
        self.pageController.completeTransition()
    }
    
}

