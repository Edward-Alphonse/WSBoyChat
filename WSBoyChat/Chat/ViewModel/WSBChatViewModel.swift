//
//  WSBChatViewModel.swift
//  WSBoyChat
//
//  Created by hezhichang on 2020/8/14.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WSBChatViewModel {
    var toolBarBottom: Driver<CGFloat> {
        return toolBarBottomRelay.asDriver()
    }
    var sendMessage = BehaviorRelay<String?>(value: nil)
    var insertMessage: Signal<IndexPath?> {
        return insertMessageRelay.asSignal(onErrorJustReturn: nil)
    }
    fileprivate(set) var dataSource:NSMutableArray = NSMutableArray()
    fileprivate var toolBarBottomRelay = BehaviorRelay<CGFloat>(value: 0)
    fileprivate var insertMessageRelay = BehaviorRelay<IndexPath?>(value: nil)
    fileprivate var disposeBag = DisposeBag()
    init() {
        createExampleData()
        addObsevers()
        setupBindings()
    }
    
    func createExampleData() {
        
        for i: Int in 0...3 {
        
            let chatCellFrame: LiuqsChatCellFrame = LiuqsChatCellFrame()
            
            let message = WSBChatMessage()
            
            var messageText = String()
            
            if i == 0 {
                
                message.user?.type = .other
                message.user?.name = "鸣人"
                message.messageType = 0
                messageText = "在村里，Lz辈分比较大，在我还是小屁孩的时候就有大人喊我叔了，这不算糗[委屈]。 成年之后，鼓起勇气向村花二丫深情表白了(当然是没有血缘关系的)[害羞]，结果她一脸淡定的回绝了:“二叔！别闹……”[尴尬]"
            }else if i == 2 {
                
                message.user?.type = .me
                message.user?.name = "路飞"
                message.messageType = 0;
                messageText = "小学六年级书法课后不知是哪个用红纸写了张六畜兴旺贴教室门上，上课语文老师看看门走了，过了一会才来，过了几天去办公室交作业听见语文老师说：看见那几个字我本来是不想进去的，但是后来一想养猪的也得进去喂猪"
            }else if i == 1 {
            
                message.user?.type = .other
                message.user?.name = "鸣人"
                message.messageType = 1
                message.gifName = "2_4"
            }else if i == 3 {
            
                message.user?.type = .me
                message.user?.name = "路飞"
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
            .bind {[weak self] (notification) in
                self?.changeToolBarBottom(noti: notification)
        }.disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .bind {[weak self] (notification) in
                self?.changeToolBarBottom(noti: notification)
        }.disposed(by: disposeBag)
    }
    
    func setupBindings() {
        sendMessage.subscribe(onNext: {[weak self] (message) in
            var messageText = "[憨笑]彩笔，怎么可以输入空格呢?[得意]"
            guard let message = message, !message.isEmpty else {
                return
            }
            messageText = message
            self?.createDataSource(text: messageText)
        }, onCompleted: {
            print("ok")
        }).disposed(by: disposeBag)
    }
    
    @objc func changeToolBarBottom(noti: Notification) {
        guard let userInfo = noti.userInfo as? [String: Any],
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        toolBarBottomRelay.accept(endFrame.minY)
    }
    
    func createDataSource(text: String) {
        let cellFrame = LiuqsChatCellFrame()
        let message = WSBChatMessage()
        message.message = text
        message.messageType = 0
        message.user?.name = "鸣人"
        cellFrame.message = message
        dataSource.add(cellFrame)
        insertMessageRelay.accept(IndexPath(row: dataSource.count - 1, section: 0))
    }
}
