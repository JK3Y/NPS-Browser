//
//  AppDelegate.swift
//  NPS Browser
//
//  Created by JK3Y on 4/28/18.
//  Copyright © 2018 JK3Y. All rights reserved.
//

import Cocoa
import Files
import SwiftyBeaver
import RealmSwift

let log = SwiftyBeaver.self

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    lazy var downloadManager: DownloadManager = DownloadManager()
    lazy var bookmarkManager: BookmarkManager = BookmarkManager()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupSwiftyBeaverLogging()
        setupDownloadsDirectory()

//        populateMasterViewTable()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        downloadManager.stopAndStoreDownloadList()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func setupSwiftyBeaverLogging() {
        let console = ConsoleDestination()
        let file = FileDestination()
        let cloud = SBPlatformDestination(appID: "Rl12gv", appSecret: "bPi6vxoi2hV7mxnAtlriT3kBXbmofepc", encryptionKey: "qkiqm2IcjwgzuCcmu6itctXna2nxLztf")

        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)
    }
    
    func setupDownloadsDirectory() {
        let dlFolder = SettingsManager().getDownloads().library_location
        let dlDirName = "NPS Downloads"
        
        try! Folder(path: dlFolder.path).createSubfolderIfNeeded(withName: dlDirName)
        log.info("Downloads folder created at \(dlFolder.appendingPathComponent(dlDirName, isDirectory: true).path)")
    }
    
//    func populateMasterViewTable() {
//        if (coreDataIO.recordsAreEmpty()) {
//            NetworkManager().makeHTTPRequest()
//        } else {
//            let content = coreDataIO.getRecords()
//            Helpers().getDataController().setArrayControllerContent(content: content)
//        }
        
//        let items = 
//    }
    
    // MARK: - Notifications
    
    func showNotification(title: String, subtitle: String) {
        let notification = NSUserNotification()
        
        notification.title = title
        notification.subtitle = subtitle
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

}

