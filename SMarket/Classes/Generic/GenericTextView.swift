//
//  GenericTextView.swift
//  SMarket
//
//  Created by Mac-00014 on 20/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

protocol GenericTextViewDelegate {
    func GenericTextViewDidChangeText(_ text:String)
    func GenericTextViewDidEndEditing(_ text:String)
}

final class GenericTextView: UITextView {
    
    var notifier:GenericTextViewDelegate?
    
    @IBInspectable var placeholder: String? {
        didSet {
            placeholderLabel?.text = placeholder
        }
    }
    
    @IBInspectable var placeholderColor  : UIColor? {
        didSet {
            placeholderLabel?.textColor = placeholderColor
        }
    }
    var placeholderFont : UIFont! {
        get {
            return self.font
        }
    }
    
    fileprivate var placeholderLabel: UILabel?
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(GenericTextView.textDidChangeHandler(notification:)), name: .UITextViewTextDidChange, object: nil)
        
        placeholderLabel = UILabel()
        placeholderLabel?.textColor = placeholderColor
        placeholderLabel?.text = placeholder
        placeholderLabel?.textAlignment = .left
        placeholderLabel?.numberOfLines = 0
        
        initialize()
    }
    
    fileprivate func initialize() {
        self.font = self.font?.setUpAppropriateFont()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.contentInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderLabel?.font = placeholderFont
        placeholderLabel?.textColor = placeholderColor
        
        var height:CGFloat = placeholderFont.lineHeight
        if let data = placeholderLabel?.text {
            
            let expectedDefaultWidth:CGFloat = bounds.size.width
            let textView = UITextView()
            textView.contentInset = self.contentInset
            textView.text = data
            textView.font = self.font
            let sizeForTextView = textView.sizeThatFits(CGSize(width: expectedDefaultWidth,
                                                               height: CGFloat.greatestFiniteMagnitude))
            let expectedTextViewHeight = sizeForTextView.height
            
            if expectedTextViewHeight > height {
                height = expectedTextViewHeight
            }
        }
        
        placeholderLabel?.frame = CGRect(x: 6, y: 0, width: bounds.size.width - 16, height: height)
        
        
        if text.isEmpty {
            addSubview(placeholderLabel!)
            bringSubview(toFront: placeholderLabel!)
        } else {
            placeholderLabel?.removeFromSuperview()
        }
    }
    
    @objc func textDidChangeHandler(notification: Notification) {
        layoutSubviews()
    }
    
}

extension GenericTextView : UITextViewDelegate {
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let charLimit = self.charLimit {
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return newText.count <= charLimit
            
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notifier?.GenericTextViewDidChangeText(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        notifier?.GenericTextViewDidEndEditing(textView.text)
    }

}
