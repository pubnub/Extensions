//
//  AppDelegate.swift
//  ExtensionApp
//
//  Created by Jordan Zucker on 9/26/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import CoreData
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let publishChannel = "publishFromExtension"

    var window: UIWindow?
    var client: PubNub!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = PNConfiguration(publishKey: "demo-36", subscribeKey: "demo-36")
        config.stripMobilePayload = false
        self.client = PubNub.clientWithConfiguration(config)
        self.client.logger.enabled = true
        self.client.logger.enableLogLevel(PNLogLevel.PNVerboseLogLevel.rawValue)
        self.client.subscribeToChannels([publishChannel], withPresence: false)
        
        return true
    }

}

