//
//  WSBWebImageView.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/23.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

final public class WSBWebImageView: FSWebImageView {
    public var placeholderName: String = "" {
        didSet {
            placeholderImage = UIImage(named: placeholderName)
        }
    }
    public var imageName: String? {
        didSet {
            didSetImageName()
        }
    }
    
    fileprivate var placeholderImage: UIImage?
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func didSetImageName() {
        defer {
            if self.image == nil {
                self.image = placeholderImage
            }
        }
        guard let imageName = imageName else {
            return
        }
        if let url = URL(string: imageName) {
            load(url: url)
            return
        }
        if let image = UIImage(named: imageName) {
            self.image = image
        }
    }
}
