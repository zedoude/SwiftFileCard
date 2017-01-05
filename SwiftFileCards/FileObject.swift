//
//  FileObject.swift
//  SwiftFileCards
//
//  Created by Cédric Ponchy on 05/01/17.
//  Copyright © 2017 Cédric Ponchy. All rights reserved.
//

import Cocoa

class FileObject: NSObject {
    var url : URL
    var name : String { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.nameKey])
            return resourcesSet.name!
        } catch {
            return ""
        }
        }
    }
    
    var localizedName : String { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.localizedNameKey])
            return resourcesSet.localizedName!
        } catch {
            return ""
        }
        }
    }

    var dateOfCreation : Date { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.creationDateKey])
            return resourcesSet.creationDate!
        } catch {
            return Date(timeIntervalSince1970: 0)
        }
        }
    }

    var dateOfLastModification : Date { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.contentModificationDateKey])
            return resourcesSet.contentModificationDate!
        } catch {
            return Date(timeIntervalSince1970: 0)
        }
        }
    }

    var icon : NSImage { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.effectiveIconKey])
            return resourcesSet.effectiveIcon! as! NSImage
        } catch {
            return NSImage()
        }
        }
    }

    var sizeInBytes : NSNumber { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.fileSizeKey])
            return NSNumber(value: resourcesSet.fileSize!)
        } catch {
            return NSNumber(value: 0)
        }
        }
    }
    

    var utiType : String { get {
        do {
            let resourcesSet = try self.url.resourceValues(forKeys: [URLResourceKey.typeIdentifierKey])
            return resourcesSet.typeIdentifier!
        } catch {
            return ""
        }
        }
    }
    
    init(url:URL) {
        self.url = url
        
    }
    static func fileObjectWithURL(url:URL) -> FileObject {
        return FileObject.init(url: url)
    }
    
}
