//
//  WSBToolBarView.swift

import UIKit

protocol WSBToolBarDelegate: class {
    func toolBarDidClick(emotionButton: UIButton)
    func toolBarSendMessage()
    func toolBarInputDidChange(_ textView: UITextView)
}

class WSBToolBarView: UIImageView {
    weak var delegate: WSBToolBarDelegate?
    var margin: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    fileprivate(set) var textView = UITextView(frame: .zero)
    fileprivate(set) var emotionButtton = UIButton(type: .custom)
    fileprivate var lineView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BACKGROUND_Color
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func loadSubviews() {
        setupLineView()
        setupTextView()
        setupEmotionButton()
        isUserInteractionEnabled = true
    }
    
    func setupLineView() {
        lineView.backgroundColor = UIColor.lightGray
        addSubview(lineView)
    }
    
    func setupTextView() {
        textView.backgroundColor = UIColor.white
        textView.returnKeyType = UIReturnKeyType.send
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 0.5
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.lightGray.cgColor;
        textView.delegate = self
        addSubview(self.textView)
    }
    
    func setupEmotionButton() {
        emotionButtton.setImage(UIImage.init(named: "wsb_chat_emotion_no"), for: UIControl.State.normal)
        emotionButtton.setImage(UIImage.init(named: "wsb_chat_emotion_se"), for: UIControl.State.selected)
        emotionButtton.addTarget(self, action: #selector(emotionButtonDidClick(button:)), for: UIControl.Event.touchUpInside)
        addSubview(emotionButtton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 8
        lineView.frame = CGRect(x: 0, y: 0, width: self.width, height: 0.5)
        emotionButtton.frame = CGRect(x: self.width - margin.right - 32, y: margin.top, width: 32, height: 32)
        let offsetX = margin.left
        textView.frame = CGRect(x: offsetX, y: margin.top, width: emotionButtton.left - offsetX - padding, height: self.height - margin.top - margin.bottom)
    }
    
    @objc func emotionButtonDidClick(button: UIButton) {
        delegate?.toolBarDidClick(emotionButton: button)
    }
}

extension WSBToolBarView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.toolBarInputDidChange(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.toolBarSendMessage()
            return false
        }
        return true
    }
}
