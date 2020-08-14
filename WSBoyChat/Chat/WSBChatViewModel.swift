//
//  WSBChatViewModel.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/14.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import RxSwift

class WSBChatViewModel {
    var dataSource:NSMutableArray = NSMutableArray()
    fileprivate var disposeBag = DisposeBag()
    init() {
        createExampleData()
    }
    
    func createExampleData() {
        
        for i: Int in 0...3 {
        
            let chatCellFrame: LiuqsChatCellFrame = LiuqsChatCellFrame()
            
            let message: LiuqsChatMessage = LiuqsChatMessage()
            
            var messageText = String()
            
            if i == 0 {
                
                message.currentUserType = userType.other
                message.userName = "鸣人"
                message.messageType = 0
                messageText = "在村里，Lz辈分比较大，在我还是小屁孩的时候就有大人喊我叔了，这不算糗[委屈]。 成年之后，鼓起勇气向村花二丫深情表白了(当然是没有血缘关系的)[害羞]，结果她一脸淡定的回绝了:“二叔！别闹……”[尴尬]"
            }else if i == 2 {
                
                message.currentUserType = userType.me
                message.userName = "路飞"
                message.messageType = 0;
                messageText = "小学六年级书法课后不知是哪个用红纸写了张六畜兴旺贴教室门上，上课语文老师看看门走了，过了一会才来，过了几天去办公室交作业听见语文老师说：看见那几个字我本来是不想进去的，但是后来一想养猪的也得进去喂猪"
            }else if i == 1 {
            
                message.currentUserType = userType.other
                message.userName = "鸣人"
                message.messageType = 1
                message.gifName = "2_4"
            }else if i == 3 {
            
                message.currentUserType = userType.me
                message.userName = "路飞"
                message.messageType = 1
                message.gifName = "2_8"
            }
            
            message.message = messageText
            
            chatCellFrame.message = message
            
            dataSource.add(chatCellFrame)
        }
    }

    func addObsevers() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .bind { (notification) in
                
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .bind { (notification) in
                
        }.disposed(by: disposeBag)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //键盘出现
    @objc func keyboardWillShow(noti:NSNotification) {
        
        let userInfo:NSDictionary = noti.userInfo! as NSDictionary
        
        let begin:CGRect = (((userInfo.object(forKey: UIResponder.keyboardFrameBeginUserInfoKey)) as? NSValue)?.cgRectValue)!
        
        let keyBoardFrame:CGRect = (((userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)) as? NSValue)?.cgRectValue)!
        
        //处理三方键盘走多次
        if begin.size.height > 0 && begin.origin.y - keyBoardFrame.origin.y > 0 {
    
//            HandleKeyBoardShow(keyBoardFrame: keyBoardFrame)
            
//            self.keyBoardH = keyBoardFrame.size.height;
        }
    }
    
    //键盘隐藏的通知事件
    @objc func keyboardWillHide(noti:NSNotification) {
        
//        self.keyBoardH = 0;
//        
//        HandleKeyBoardHide()
    }
}
