//
//  WSBLoginViewCellTableViewCell.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/6.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit

protocol WSBLoginViewCellProtocol {
    var textInputView: WSBLoginInputView { get set }
}

typealias WSBLoginViewCellType = UITableViewCell & WSBLoginViewCellProtocol

class WSBLoginViewAccountCell: WSBLoginViewCellType {
    
    var textInputView = WSBLoginInputView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadSubviews()
    }
    
    func loadSubviews() {
        
    }
}
