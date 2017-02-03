//
//  ImageHandler.swift
//  ExtensionApp
//
//  Created by Jordan Zucker on 2/3/17.
//  Copyright © 2017 Jordan Zucker. All rights reserved.
//

import UIKit

class ImageHandler: NSObject {
    
    static func resizedImage(_ image: UIImage, targetWidth: CGFloat) -> UIImage {
        
        let scale = targetWidth / image.size.width
        let targetHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func base64String(for image: UIImage, compressed: Bool = true) -> String? {
        let compressedImage = UIImageJPEGRepresentation(image, 0.45)
        return compressedImage?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
    }

}
