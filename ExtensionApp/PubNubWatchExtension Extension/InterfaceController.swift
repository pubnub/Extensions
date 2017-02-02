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
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Actions
    
    @IBAction func publishButtonPressed(sender: WKInterfaceButton) {
        var message = [String:Any]()
        message["message"] = "Hello, [watch]world!"
        client.publish(message, toChannel: publishChannel) { (status) in
            var publishStatusText = "Publish succeeded!"
            if status.isError {
                print("Publish failed")
                publishStatusText = "Publish failed!"
            }
            self.publishStatusLabel.setText(publishStatusText)
        }
    }

}
