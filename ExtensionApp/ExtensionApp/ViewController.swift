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
    
    @IBOutlet weak var imageHolderView: UIImageView!
    @IBOutlet weak var messageHolderLabel: UILabel!
    
    var clearMessageButton: UIButton!
    var client: PubNub!
    

    override func viewDidLoad() {
        
        // Forward method call to the super class.
        super.viewDidLoad()
        
        clearMessageButton = UIButton(type: .system)
        clearMessageButton.addTarget(self, action: #selector(clearMessageButtonPressed(sender:)), for: .touchUpInside)
        clearMessageButton.setTitle("Press here to clear message", for: .normal)
        clearMessageButton.titleLabel?.textAlignment = .center
        clearMessageButton.translatesAutoresizingMaskIntoConstraints = false
        clearMessageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(clearMessageButton)
        clearMessageButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        clearMessageButton.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        clearMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        clearMessageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0).isActive = true
        
        
        imageHolderView.backgroundColor = .clear
        
        let backgroundInstructionsLabel = UILabel(frame: .zero)
        view.addSubview(backgroundInstructionsLabel)
        view.sendSubview(toBack: backgroundInstructionsLabel)
        backgroundInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundInstructionsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backgroundInstructionsLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        backgroundInstructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundInstructionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundInstructionsLabel.backgroundColor = .clear
        backgroundInstructionsLabel.text = "Publish a message from the Share or Watch Extension to see it here"
        backgroundInstructionsLabel.textAlignment = .center
        backgroundInstructionsLabel.numberOfLines = 0
        backgroundInstructionsLabel.adjustsFontSizeToFitWidth = true
        
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
            
            if self.messageHolderLabel.text?.characters.count == 0 {
                
                self.client.historyForChannel(self.publishChannel, start: nil, end: nil, limit: 1, 
                                              withCompletion: { (result, status) in
                    
                    if status == nil { 
                        
                        self.showMessage(result?.data.messages.first as! Dictionary<String, Any>)
                    }
                })  
            }
        }
    }
    
    // MARK: - Actions
    
    func clearMessageButtonPressed(sender: UIButton) {
        imageHolderView.image = nil
        messageHolderLabel.text = nil
        view.setNeedsLayout()
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
                    
                    self.imageHolderView.image = UIImage(data: imageData)
                }
            }
        }
    }
}

