//
//  ShareViewController.swift
//  PubNubShareExtension
//
//  Created by Jordan Zucker on 9/26/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social
import PubNub

class ShareViewController: SLComposeServiceViewController {
    
    let publishChannel = "publishFromExtension"
    
    lazy var client: PubNub! = {
        
        // Create PubNub client
        let configuration = PNConfiguration(publishKey: "demo-36", subscribeKey: "demo-36")
        configuration.stripMobilePayload = false
        configuration.applicationExtensionSharedGroupIdentifier = "group.PubNub.sharedContainer"
        
        return PubNub.clientWithConfiguration(configuration)
    }()
    
    override func viewDidLoad() {
        
        // Forward method call to the super class.
        super.viewDidLoad();
        
        // Configure components and delegates.
        self.placeholder = "Please input message to be published via PubNub."
        self.textView.delegate = self;
    }
    
    override func isContentValid() -> Bool {
        
        return !self.contentText.isEmpty
    }

    
    // MARK: Handle user actions
    
    override func didSelectPost() {
        
        guard let inputItems: Array<NSExtensionItem> = self.extensionContext!.inputItems as? Array<NSExtensionItem>,
            inputItems.count > 0 else {
            
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var message = [String:Any]()
        message["message"] = self.contentText
        
        let inputItem = inputItems.first
        guard let itemProvider = inputItem?.attachments?.first as? NSItemProvider else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
            
            self.base64EncodedImageFromProvider(itemProvider, withCompletion: { (base64String) in
                
                if let safeBase64String = base64String { message["image"] = safeBase64String; }
                self.publishMessage(message)
            })
        }
        else { publishMessage(message) }
    }

    override func configurationItems() -> [Any]! {
        
        return []
    }
    
    // MARK: UITextViewDelegate

    override func textViewDidChange(_ textView: UITextView) {
         
        super.validateContent()
    }
    
    func publishMessage(_ message: Any) {
        
        self.client.publish(message, toChannel: publishChannel) { (status) in
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    func base64EncodedImageFromProvider(_ provider: NSItemProvider, 
                                        withCompletion completion: @escaping (_ base64String: String?) -> Void) {
        
        provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, 
                          completionHandler: { (imageURL, error) in
                                
            if let safeImageURL: URL = (imageURL as? URL) {
                
                do {
                    
                    let imageData = try Data(contentsOf: safeImageURL)
                    let loadedImage = ImageHandler.resizedImage(UIImage(data: imageData)!, targetWidth: 200);
                    if let encodedImage = ImageHandler.base64String(for: loadedImage) {
                        completion(encodedImage)
                    }
                }
                catch { completion(nil) }
            }
            else { completion(nil)  }
        })
    }
    
}
