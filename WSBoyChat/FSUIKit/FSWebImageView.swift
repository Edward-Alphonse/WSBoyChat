//
//  WSBWebImage.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/23.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation


import UIKit

fileprivate let imageCache = NSCache<NSURL, UIImage>()

public class FSWebImageView: UIImageView {
    
    public struct Configuration {
        var placeholderImage: UIImage? = nil
        var animationDuration: TimeInterval = 0.3
        var animationOptions: UIView.AnimationOptions = .transitionCrossDissolve
    }
    
    fileprivate var currentTask: URLSessionTask? {
        didSet {
            oldValue?.cancel()
            currentTask?.resume()
        }
    }
    
    fileprivate var originRequsetURL: URL?
    var responseURL: URL?
    
    public var configuration = Configuration()
    
}

// Web Request
extension FSWebImageView {
    
    public func load(url: URL) {
        self.originRequsetURL = url
        let request = URLRequest(url: url)
        
        
        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                guard let imageView = self else { return }
                let configuration = imageView.configuration
                UIView.transition(with: imageView, duration: configuration.animationDuration, options: configuration.animationOptions, animations: {
                    imageView.image = imageFromCache
                }, completion: nil)
            }
            return
        } else {
            image = configuration.placeholderImage
        }
        
        currentTask = URLSession.shared.dataTask(with: request) { [weak self] (callbackData, response, error) in
            guard let imageView = self else { return }
            if let error = error {
                print("Network Error: ", error)
            }
            
            guard let responseURL = response?.url else { return }
            guard imageView.originRequsetURL == responseURL else { return }
            guard let data = callbackData else { return }
            guard let cgImage = imageView.makeThumbnail(data: data, maxPixelSize: 512) else { return }
            let image = UIImage(cgImage: cgImage)
            
            let configuration = imageView.configuration
            
            // back to main thread to do ui change
            DispatchQueue.main.async {
                UIView.transition(with: imageView, duration: configuration.animationDuration, options: configuration.animationOptions, animations: {
                    imageView.image = image
                }, completion: nil)
            }
            imageView.responseURL = responseURL
            imageCache.setObject(image, forKey: url as NSURL)
        }
    }
    
}

// Make Thumbnail
extension FSWebImageView {
    fileprivate func makeThumbnail(data: Data, maxPixelSize: Int) -> CGImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options = [
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
            kCGImageSourceThumbnailMaxPixelSize : maxPixelSize
            ] as CFDictionary
        return CGImageSourceCreateThumbnailAtIndex(source, 0, options)
    }
}
