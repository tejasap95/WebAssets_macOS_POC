//
//  AppDelegate.swift
//  3
//
//  Created by Patel, Tejas on 12/10/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    
    var webViewWindowController: WebViewWindowController?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        webViewWindowController = WebViewWindowController(windowNibName: "WebViewWindowController")
        webViewWindowController?.showWindow(self)
        
        webViewWindowController?.setUsernameInWebView(username: "Tejas")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

