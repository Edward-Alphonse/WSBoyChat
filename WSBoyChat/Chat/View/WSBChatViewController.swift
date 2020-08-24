//
//  WSBChatViewController.swift
//  WSBoyChat
//
//  Created by zhichang.he on 2020/8/14.
//  Copyright © 2020 zhichang.he. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WSBChatViewController: WSBBaseViewController ,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate, LiuqsEmotionKeyBoardDelegate {
    
    var viewModel = WSBChatViewModel()
    var toolBarView: WSBToolBarView = WSBToolBarView(frame: .zero)
    var emotionview = LiuqsEmotionKeyBoard(frame: .zero)
    var keyBoardH:CGFloat = CGFloat()
    var tableView:UITableView = UITableView()
    let toolBarHeight: CGFloat = 48
    fileprivate var disposeBag = DisposeBag()

//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(true)
//
////        self.navigationController?.delegate = self
//
//        scrollTableViewToBottom()
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupToolBarView()
        setupEmotionView()
        setupBindings()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(self.emotionview)
        self.emotionview.KeyTextView = self.toolBarView.textView;
    }

    func setupSubviews() {
        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationBar.title = "路飞"
        setupTableView()
    }
    
    func setupBindings() {
        viewModel.toolBarBottom.skip(1).drive(onNext: { [weak self] (bottom) in
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.toolBarView.bottom = bottom
            }
        }).disposed(by: disposeBag)
        
        viewModel.insertMessage.emit(onNext: {[weak self] (indexPath) in
            guard let indexPath = indexPath else {
                return
            }
            self?.insertMessage(at: indexPath)
        }, onCompleted: {
            print("---------aaaaa")
        }).disposed(by: disposeBag)
    }
    
    //创建tabbleView
    func setupTableView() {
        let offsetY = Utility.navigationBarHeight()
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: offsetY, width: self.view.width, height: self.view.height - offsetY - toolBarHeight))
//        tableView.contentInsetAdjustmentBehavior = .always
        tableView.backgroundColor = BACKGROUND_Color
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WSBChatMessageCell.self, forCellReuseIdentifier: WSBChatMessageCell.identifier)
        self.view.addSubview(tableView)
        
        //单击手势,用于退出键盘
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind {[weak self] (recognizer) in
            self?.tapTable()
        }.disposed(by: disposeBag)
        tableView.addGestureRecognizer(tap)
    }
    
    //创建工具条
    func setupToolBarView() {
        let yOffset: CGFloat = self.view.height - toolBarHeight
        toolBarView.frame = CGRect(x: 0, y: yOffset, width: self.view.width, height: toolBarHeight)
        toolBarView.delegate = self
//        toolBarView.textView.delegate = self
        self.view.addSubview(toolBarView)
    }
    
    func setupEmotionView() {
        emotionview.frame = CGRect.init(x: 0, y: screenH, width: screenW, height: EMOJI_KEYBOARD_HEIGHT)
        emotionview.delegate = self
        self.view.addSubview(emotionview)
    }
    
    //手势事件
    func tapTable() {
        if toolBarView.textView.isFirstResponder {
            toolBarView.textView.resignFirstResponder()
        }
//        resetChatList()
//        toolBarView.emotionButtton.isSelected = false
        
//        if toolBarView.textView.text.count == 0 {
//
//            UIView.animate(withDuration: emotionTipTime, animations: {
//
//                self.emotionview.frame = emotionDownFrame
//
//                self.toolBarView.frame = toolBarFrameDown
//
//                self.resetChatList()
//            })
//
//        }else {
//
//            UIView.animate(withDuration: emotionTipTime, animations: {
//
//                self.emotionview.frame = emotionDownFrame
//
//                self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolBarView.frame.size.height, width: screenW, height: self.toolBarView.frame.size.height)
//
//                self.resetChatList()
//            })
//        }
    }

   
    
   
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WSBChatMessageCell.identifier) as? WSBChatMessageCell else {
            return UITableViewCell(frame: .zero)
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let chatCellFrame:LiuqsChatCellFrame = viewModel.dataSource.object(at: indexPath.row) as! LiuqsChatCellFrame
        
        cell.chatCellFrame = chatCellFrame
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        self.navigationController?.pushViewController(ChatDetailViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let chatCellFrame:LiuqsChatCellFrame = viewModel.dataSource.object(at: indexPath.row) as! LiuqsChatCellFrame
        
        return chatCellFrame.cellHeight;
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        tapTable()
    }
    
    //toolBar代理
    
    
    //重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
    func resetChatList() {
    
        let offSetY:CGFloat = tableView.contentSize.height - tableView.height;
        //判断是否滚动到底部，会有一个误差值
        if tableView.contentOffset.y > offSetY - 5 || tableView.contentOffset.y > offSetY + 5 {
            
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.y, width: screenW, height: self.toolBarView.y - 64)
            
            scrollTableViewToBottom()
            
        }else {
            
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.y, width: screenW, height: self.toolBarView.y - 64)
        }
    }
    
    //滚动到底部
    func scrollTableViewToBottom() {
        if viewModel.dataSource.count > 0 {
            
        let indexPath:NSIndexPath = NSIndexPath.init(row: viewModel.dataSource.count - 1, section: 0)
        
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
        }
    }

    //textView代理事件
    
    
    //keyBoard代理
    func emotionView_sBtnDidClick(btn:UIButton) {
    
//       textViewDidChange(toolBarView.textView)
//
//        if btn.tag == 44 {//发送按钮
//
//           sendMessage()
//        }
    }
    
    func gifBtnClick(btn:UIButton) {
    
        print("动态按钮\(btn.tag)");
        
        let gifName = "2_\(btn.tag)"
        
        sendGifmessage(gifname: gifName)
    }
    
    func sendGifmessage(gifname:String){
        
        let cellFrame = LiuqsChatCellFrame()
        
        let message   = WSBChatMessage()
        
        message.messageType = 1
        
        message.message = ""
        
        message.user?.name = "鸣人"
        
        message.gifName = gifname
        
        message.user?.type = .other
        
        cellFrame.message = message
        
        viewModel.dataSource.add(cellFrame)
        
//        refreshChatList()
    }
    
    //发送消息
//    func sendMessage() {
//        
//        var messageText = String()
//        if toolBarView.textView.textStorage.length != 0 {
//            messageText = toolBarView.textView.textStorage.getPlainString()
//        }else {
//           messageText = "[憨笑]彩笔，怎么可以输入空格呢?[得意]"
//        }
//        createDataSource(text: messageText)
//        refreshChatList()
//        
//    }
    
    //创建一条数据
//    func createDataSource(text:String) {
//        let cellFrame = LiuqsChatCellFrame()
//        let message = WSBChatMessage()
//        message.message = text
//        message.messageType = 0
//        message.userName = "鸣人"
//        cellFrame.message = message
//        viewModel.dataSource.add(cellFrame)
//        
//    }
    
    //刷新UI
    func insertMessage(at indexPath: IndexPath) {
        let indexPath:NSIndexPath = NSIndexPath.init(row: viewModel.dataSource.count - 1, section: 0)
        
        tableView.insertRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)

        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    func changeToolBarFrame(contentSize: CGSize) {
        var toolBarHeight: CGFloat = self.toolBarHeight
        let contentHeight = contentSize.height
        if contentSize.height > toolBarHeight - 2 * 8 {
            toolBarHeight = contentHeight + toolBarView.margin.top + toolBarView.margin.bottom
        }
        toolBarHeight = max(toolBarHeight, self.toolBarHeight)
        toolBarHeight = min(toolBarHeight, 94)
        if toolBarView.height != toolBarHeight {
            let toolBarBottom = toolBarView.bottom
            toolBarView.height = toolBarHeight
            toolBarView.bottom = toolBarBottom
        }
    }
}


extension WSBChatViewController: WSBToolBarDelegate {
    func toolBarDidClick(emotionButton: UIButton) {
        toolBarView.textView.becomeFirstResponder()
    }
    
    func toolBarSendMessage() {
        let message = toolBarView.textView.textStorage.getPlainString()
        toolBarView.textView.text = ""
        toolBarView.textView.resignFirstResponder()
        viewModel.sendMessage.accept(message)
    }
    
    func toolBarInputDidChange(_ textView: UITextView) {
        changeToolBarFrame(contentSize: textView.contentSize)
    }
}







