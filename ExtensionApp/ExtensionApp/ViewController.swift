//
//  ViewController.swift
//  ExtensionApp
//
//  Created by Jordan Zucker on 9/26/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController, PNObjectEventListener {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("couldn't find app delegate")
        }
        appDelegate.client?.addListener(self) // don't need to remove, will happen automatically with deallocation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PNObjectEventListener
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        print("\(#function) client: \(client.debugDescription) message: \(status.debugDescription)")
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        print("\(#function) client: \(client.debugDescription) message: \(message.debugDescription)")
    }


}

