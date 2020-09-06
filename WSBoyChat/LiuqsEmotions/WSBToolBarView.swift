//
//  WSBToolBarView.swift

import UIKit

protocol WSBToolsBarDelegate: class {
    func toolsBar(_ toolsBar: WSBToolsBarView, didClickOn button: WSBToolsButton)
    func toolBarSendMessage()
    func toolBarInputDidChange(_ textView: UITextView)
}



class WSBToolsButton: UIButton {
    enum Category {
        case emotion
        case more
    }
    var category: Category
    
    override init(frame: CGRect) {
        category = .more
        super.init(frame: frame)
    }
    
    init(category: WSBToolsButton.Category) {
        self.category = .more
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WSBToolsBarView: UIImageView {
    weak var delegate: WSBToolsBarDelegate?
    var margin: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    fileprivate(set) var textView = UITextView(frame: .zero)
    fileprivate(set) var emotionButtton = WSBToolsButton(category: .emotion)
    fileprivate(set) var moreButton = WSBToolsButton(category: .more)
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
        setupMoreButton()
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
        emotionButtton.addTarget(self, action: #selector(buttonDidClick(button:)), for: UIControl.Event.touchUpInside)
        addSubview(emotionButtton)
    }
    
    func setupMoreButton() {
        moreButton.setImage(UIImage.init(named: "wsb_chat_add"), for: UIControl.State.normal)
        moreButton.addTarget(self, action: #selector(buttonDidClick(button:)), for: UIControl.Event.touchUpInside)
        addSubview(moreButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 8
        lineView.frame = CGRect(x: 0, y: 0, width: self.width, height: 0.5)
        moreButton.frame = CGRect(x: self.width - margin.right - 32, y: margin.top, width: 32, height: 32)
        emotionButtton.frame = CGRect(x: moreButton.left - 8 - 32, y: margin.top, width: 32, height: 32)
        let offsetX = margin.left
        textView.frame = CGRect(x: offsetX, y: margin.top, width: emotionButtton.left - offsetX - padding, height: self.height - margin.top - margin.bottom)
    }
    
    @objc func buttonDidClick(button: WSBToolsButton) {
        delegate?.toolsBar(self, didClickOn: button)
    }
}

extension WSBToolsBarView: UITextViewDelegate {
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
