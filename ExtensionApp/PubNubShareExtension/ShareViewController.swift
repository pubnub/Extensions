//
//  ShareViewController.swift
//  PubNubShareExtension
//
//  Created by Jordan Zucker on 9/26/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import Social
import PubNub

class ShareViewController: SLComposeServiceViewController {
    
    let publishChannel = "publishFromExtension"
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        
        // create PubNub client
        let config = PNConfiguration(publishKey: "demo-36", subscribeKey: "demo-36")
        let client = PubNub.clientWithConfiguration(config)
        client.logger.enabled = true
        client.logger.enableLogLevel(PNLogLevel.PNVerboseLogLevel.rawValue)
 
        /*
        let configName = "com.PubNub.shareExtension"
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: configName)
        // Extensions aren't allowed their own cache disk space. Need to share with application
        sessionConfig.sharedContainerIdentifier = "group.PubNub.sharedContainer"
        let session = URLSession(configuration: sessionConfig)
        session.dataTask(with: URL(string: "http://httpbin.org")!).resume()
        */
        guard let inputItems = self.extensionContext?.inputItems, inputItems.count > 0 else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var message = [String:String]()
        message["example"] = "ExtensionItem"
        
        for inputItem in inputItems {
            guard let extensionItem = inputItem as? NSExtensionItem else {
                fatalError("encountered unknown type")
            }
            print("extensionItem: \(extensionItem)")
            if let inputString = extensionItem.attributedContentText {
                message["inputString"] = inputString.string
            }
        }
        print("message: \(message)")
        client.publish(message, toChannel: publishChannel) { (status) in
            print("publishStatus: \(status.debugDescription)")
            // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
