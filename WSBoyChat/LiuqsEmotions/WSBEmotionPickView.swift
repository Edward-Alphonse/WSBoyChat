//
//  WSBEmotionPickView.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/9/8.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

class WSBEmotionPickView: UIView {

    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadSubviews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
    }
}
