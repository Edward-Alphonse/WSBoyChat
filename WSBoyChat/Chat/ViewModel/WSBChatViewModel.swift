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
    var refreshSignal: Signal<Void> {
        return refreshRelay.asSignal(onErrorJustReturn: ())
    }

    fileprivate(set) var cellModels = [WSBChatMessageCellModel]()
    fileprivate var toolBarBottomRelay = BehaviorRelay<CGFloat>(value: 0)
    fileprivate var insertMessageRelay = BehaviorRelay<IndexPath?>(value: nil)
    fileprivate var refreshRelay = BehaviorRelay<Void>(value: ())
    fileprivate var disposeBag = DisposeBag()
    init() {
        createExampleData()
        addObsevers()
        initNetwork()
        setupBindings()
    }
    
    func initNetwork() {
        WSBNetworkManager.shared.connect(host: "192.168.1.8", port: "21567")
    }
    
    func createExampleData() {
        DispatchQueue.global().async { [weak self] in
            for i: Int in 0...3 {
                let message = WSBChatMessage()
                if i == 0 {
                    message.user?.type = .other
                    message.user?.name = "鸣人"
                    message.type = .text
                    message.message = "在村里，Lz辈分比较大，在我还是小屁孩的时候就有大人喊我叔了，这不算糗[委屈]。 成年之后，鼓起勇气向村花二丫深情表白了(当然是没有血缘关系的)[害羞]，结果她一脸淡定的回绝了:“二叔！别闹……”[尴尬]"
                }else if i == 2 {
                    message.user?.type = .me
                    message.user?.name = "路飞"
                    message.type = .text
                    message.message = "小学六年级书法课后不知是哪个用红纸写了张六畜兴旺贴教室门上，上课语文老师看看门走了，过了一会才来，过了几天去办公室交作业听见语文老师说：看见那几个字我本来是不想进去的，但是后来一想养猪的也得进去喂猪"
                }else if i == 1 {
                    message.user?.type = .other
                    message.user?.name = "鸣人"
                    message.type = .gif
                    message.gifName = "2_4"
                }else if i == 3 {
                    message.user?.type = .me
                    message.user?.name = "路飞"
                    message.type = .gif
                    message.gifName = "2_8"
                }
                let cellModel = WSBChatMessageCellModel(model: message)
                self?.cellModels.append(cellModel)
            }
            DispatchQueue.main.async {
                self?.refreshRelay.accept(())
            }
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
        sendMessage.skip(1).subscribe(onNext: {[weak self] (message) in
            guard let message = message, !message.isEmpty else {
                return
            }
            self?.send(message: message)
        }, onCompleted: {
            print("ok")
        }).disposed(by: disposeBag)
    }
    
    func send(message: String) {
        createDataSource(text: message)
        DispatchQueue.global().async {
            WSBNetworkManager.shared.send(string: message) { [weak self] (data) in
                guard let message = (String(data: data, encoding: .utf8)) else {
                    return
                }
                DispatchQueue.main.async {
                    self?.createOtherCellModel(msg: message)
                }
            }
        }
    }
    
    @objc func changeToolBarBottom(noti: Notification) {
        guard let userInfo = noti.userInfo as? [String: Any],
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        toolBarBottomRelay.accept(endFrame.minY)
    }
    
    func createDataSource(text: String) {
        let message = WSBChatMessage()
        message.message = text
        message.type = .text
        message.user?.name = "鸣人"
        let cellModel = WSBChatMessageCellModel(model: message)
        cellModels.append(cellModel)
        insertMessageRelay.accept(IndexPath(row: cellModels.count - 1, section: 0))
    }
    
    func createOtherCellModel(msg: String) {
        let message = WSBChatMessage()
        message.message = msg
        message.type = .text
        message.user?.name = "啥时给"
        message.user?.type = .other
        let cellModel = WSBChatMessageCellModel(model: message)
        cellModels.append(cellModel)
        insertMessageRelay.accept(IndexPath(row: cellModels.count - 1, section: 0))
    }
    
    subscript(index: Int) -> WSBChatMessageCellModel? {
        guard index < cellModels.count else {
            return nil
        }
        return cellModels[index]
    }
}
