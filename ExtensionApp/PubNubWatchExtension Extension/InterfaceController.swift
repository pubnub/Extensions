//
//  InterfaceController.swift
//  PubNubWatchExtension Extension
//
//  Created by Jordan Zucker on 2/1/17.
//  Copyright © 2017 Jordan Zucker. All rights reserved.
//

import WatchKit
import Foundation
import PubNub


class InterfaceController: WKInterfaceController {
    
    let publishChannel = "publishFromExtension"
    
    lazy var client: PubNub! = {
        
        // Create PubNub client
        let configuration = PNConfiguration(publishKey: "demo-36", subscribeKey: "demo-36")
        configuration.stripMobilePayload = false
        configuration.applicationExtensionSharedGroupIdentifier = "group.PubNub.sharedContainer"
        
        return PubNub.clientWithConfiguration(configuration)
    }()
    
    @IBOutlet weak var publishButton: WKInterfaceButton!
    @IBOutlet weak var publishStatusLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        publishButton.setTitle("Publish")
        publishStatusLabel.setText("Publish via PubNub")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        publishButton.setEnabled(true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Actions
    
    @IBAction func publishButtonPressed(sender: WKInterfaceButton) {
        publishButton.setEnabled(false)
        var message = [String:Any]()
        message["message"] = "Hello, [watch]world!"
        
        if let capturedScreenshot = UIImage(named: "apple-watch-pubnub.png") {
            let compressedImage = ImageHandler.resizedImage(capturedScreenshot, targetWidth: 200.0)
            if let finalString = ImageHandler.base64String(for: compressedImage) {
                message["image"] = finalString
            }
        }
        
        print("try to publish: \(message)")
        
        client.publish(message, toChannel: publishChannel) { (status) in
            self.publishButton.setEnabled(true)
            var publishStatusText = "Publish succeeded!"
            if status.isError {
                print("Publish failed")
                publishStatusText = "Publish failed!"
            }
            self.publishStatusLabel.setText(publishStatusText)
        }
    }

}
