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

class WSBChatViewController: WSBBaseViewController ,UITextViewDelegate ,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate, LiuqsToolBarDelegate, LiuqsEmotionKeyBoardDelegate {
    
    var viewModel = WSBChatViewModel()
    var toolBarView:LiuqsToolBarView = LiuqsToolBarView.init(frame: CGRect())
    var keyBoardH:CGFloat = CGFloat()
    var tableView:UITableView = UITableView()
    fileprivate var disposeBag = DisposeBag()
    
    
    lazy private var emotionview: LiuqsEmotionKeyBoard = {
        let emotionview = LiuqsEmotionKeyBoard.init(frame: CGRect.init(x: 0, y: screenH, width: screenW, height: EMOJI_KEYBOARD_HEIGHT))
        emotionview.delegate = self
        return emotionview
    }()
    
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        super.viewWillAppear(true)
//
////        self.navigationController?.delegate = self
//
//        ScrollTableViewToBottom()
//
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.addSubview(self.emotionview)
        
        self.emotionview.KeyTextView = self.toolBarView.textView;
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        addObsevers()
        
        creatToolBarView()
    }
    
    func setupSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBar.title = "路飞"
        setupTableView()
    }
    
    
    
    //创建tabbleView
    func setupTableView() {
        let offsetY = Utility.navigationBarHeight()
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: offsetY, width: self.view.width, height: self.view.height - offsetY - 48))
        
        tableView.backgroundColor = BACKGROUND_Color
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LiuqsChatMessageCell.self, forCellReuseIdentifier: "LiuqsChatMessageCell")
        self.view.addSubview(tableView)
        
        //单击手势,用于退出键盘
        let tap = UITapGestureRecognizer()
        tap.rx.event.bind {[weak self] (recognizer) in
            self?.tapTable()
        }.disposed(by: disposeBag)
        tableView.addGestureRecognizer(tap)
    }
    
    //手势事件
    func tapTable() {
    
        if toolBarView.textView.isFirstResponder {
            
            toolBarView.textView.resignFirstResponder()
        }
    
        toolBarView.toolBarEmotionBtn.isSelected = false
        
        if toolBarView.textView.text.count == 0 {
        
            UIView.animate(withDuration: emotionTipTime, animations: {
                
                self.emotionview.frame = emotionDownFrame
                
                self.toolBarView.frame = toolBarFrameDown
    
                self.resetChatList()
            })
            
        }else {
            
            UIView.animate(withDuration: emotionTipTime, animations: {
            
                self.emotionview.frame = emotionDownFrame
                
                self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolBarView.frame.size.height, width: screenW, height: self.toolBarView.frame.size.height)
            
                self.resetChatList()
            })
        }
    }

    //处理键盘弹出
    func HandleKeyBoardShow(keyBoardFrame:CGRect) {
     
        //键盘弹出
        UIView.animate(withDuration: emotionTipTime, animations: {
            
            self.toolBarView.toolBarEmotionBtn.isSelected = false
            
            self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolBarView.height - keyBoardFrame.size.height , width: screenW, height: self.toolBarView.height)
            
            self.resetChatList()
            
            }) { (Bool) in
                
           self.emotionview.frame = emotionUpFrame
        }
    }
    
    //处理键盘收起
    func HandleKeyBoardHide() {
        
        //键盘收起
        self.toolBarView.toolBarEmotionBtn.isSelected = true
        
        UIView.animate(withDuration: emotionTipTime, animations: {
            
            self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolBarView.height - self.emotionview.height, width: screenW, height: self.toolBarView.height)
            
            self.resetChatList()
        })
    }
    
    //创建工具条
    func creatToolBarView() {
    
        toolBarView.delegate = self
        
        toolBarView.textView.delegate = self
        
        self.view.addSubview(toolBarView)
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LiuqsChatMessageCell.cellWithTableView(tableView: tableView)
        
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
    func ToolbarEmotionBtnDidClicked(emotionBtn: UIButton) {
        
        if emotionBtn.isSelected {
        
            emotionBtn.isSelected = false;
            
            toolBarView.textView.becomeFirstResponder()
            
        }else {
        
            toolBarView.textView.resignFirstResponder()
            
            emotionBtn.isSelected = true
            
            UIView.animate(withDuration: emotionTipTime, animations: {
                
                self.emotionview.frame = emotionUpFrame
                
                self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolBarView.height - self.emotionview.height, width: screenW, height: self.toolBarView.height)
                print(self.toolBarView.frame.origin.y)
                self.resetChatList()
            })
        }
    }
    
    //重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
    func resetChatList() {
    
        let offSetY:CGFloat = tableView.contentSize.height - tableView.height;
        //判断是否滚动到底部，会有一个误差值
        if tableView.contentOffset.y > offSetY - 5 || tableView.contentOffset.y > offSetY + 5 {
            
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.y, width: screenW, height: self.toolBarView.y - 64)
            
            ScrollTableViewToBottom()
            
        }else {
            
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.y, width: screenW, height: self.toolBarView.y - 64)
        }
    }
    
    //滚动到底部
    func ScrollTableViewToBottom() {
        if viewModel.dataSource.count > 0 {
            
        let indexPath:NSIndexPath = NSIndexPath.init(row: viewModel.dataSource.count - 1, section: 0)
        
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
        }
    }

    //textView代理事件
    func textViewDidChange(_ textView: UITextView) {
        
        if (self.toolBarView.textView.contentSize.height <= TextViewH) {
            
            self.toolBarView.textView.height = TextViewH;
            
        }else if (self.toolBarView.textView.contentSize.height >= 90) {
            
            self.toolBarView.textView.height = 90;
            
        }else {
            
            self.toolBarView.textView.height = self.toolBarView.textView.contentSize.height;
        }
        
        self.toolBarView.height = screenW * 10 / 320 + self.toolBarView.textView.height;
        
        if (self.keyBoardH < self.emotionview.height) {
            
            self.toolBarView.y = screenH - self.toolBarView.height - self.emotionview.height;
            
        }else {
            
            self.toolBarView.y = screenH - self.toolBarView.height - self.keyBoardH;
        }
        if (textView.text.count > 0) {
            
            self.emotionview.sendBtn.isSelected = true;
            
        }else {
            
            self.emotionview.sendBtn.isSelected = false;
        }
    
        self.tableView.height = self.toolBarView.y - 64
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            sendMessage()
            
            return false
        }
        
        return true;
    }
    
    //keyBoard代理
    func emotionView_sBtnDidClick(btn:UIButton) {
    
       textViewDidChange(toolBarView.textView)
        
        if btn.tag == 44 {//发送按钮
            
           sendMessage()
        }
    }
    
    func gifBtnClick(btn:UIButton) {
    
        print("动态按钮\(btn.tag)");
        
        let gifName = "2_\(btn.tag)"
        
        sendGifmessage(gifname: gifName)
    }
    
    func sendGifmessage(gifname:String){
        
        let cellFrame = LiuqsChatCellFrame()
        
        let message   = LiuqsChatMessage()
        
        message.messageType = 1
        
        message.message = ""
        
        message.userName = "鸣人"
        
        message.gifName = gifname
        
        message.currentUserType = userType.other
        
        cellFrame.message = message
        
        viewModel.dataSource.add(cellFrame)
        
        refreshChatList()
    }
    
    //发送消息
    func sendMessage() {
        
        var messageText = String()
        
        if toolBarView.textView.textStorage.length != 0 {
            
            messageText = toolBarView.textView.textStorage.getPlainString()
        }else {
        
           messageText = "[憨笑]彩笔，怎么可以输入空格呢?[得意]"
        }
        
        createDataSource(text: messageText)
        
        refreshChatList()
        
    }
    
    //创建一条数据
    func createDataSource(text:String) {
    
        let cellFrame = LiuqsChatCellFrame()
        
        let message   = LiuqsChatMessage()
        
        message.message = text
        
        message.messageType = 0
        
        message.userName = "鸣人"
        
        message.currentUserType = userType.other
        
        cellFrame.message = message

        viewModel.dataSource.add(cellFrame)
        
    }
    
    //刷新UI
    func refreshChatList() {
    
        toolBarView.textView.text = ""
        
        textViewDidChange(toolBarView.textView)
        
        let indexPath:NSIndexPath = NSIndexPath.init(row: viewModel.dataSource.count - 1, section: 0)
        
        tableView.insertRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)

        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
}








