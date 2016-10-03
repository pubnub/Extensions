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
    
    let publishChannel = "publishFromExtension"
    
    @IBOutlet weak var imageHolderView: UIImageView?
    @IBOutlet weak var messageHolderLabel: UILabel?
    var client: PubNub!
    

    override func viewDidLoad() {
        
        // Forward method call to the super class.
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("couldn't find app delegate")
        }
        client = appDelegate.client;
        client.addListener(self) // don't need to remove, will happen automatically with deallocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Forward method call to the super class.
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { 
            
            if self.messageHolderLabel?.text?.characters.count == 0 {
                
                self.client.historyForChannel(self.publishChannel, start: nil, end: nil, limit: 1, 
                                              withCompletion: { (result, status) in
                    
                    if status == nil { 
                        
                        self.showMessage(result?.data.messages.first as! Dictionary<String, Any>)
                    }
                })  
            }
        }
    }
    
    // MARK: - PNObjectEventListener
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        if let safeMessage = message.data.message { showMessage(safeMessage as! Dictionary<String, Any>) }
    }

    private func showMessage(_ message: Dictionary<String, Any>) {
        
        if message.count > 0 {
            
            self.messageHolderLabel?.text = message["message"] as! String?
            if let base64EncodedImage = message["image"] as! String? {
                
                if let imageData = Data(base64Encoded: base64EncodedImage, options: []) {
                    
                    self.imageHolderView?.image = UIImage(data: imageData)
                }
            }
        }
    }
}

