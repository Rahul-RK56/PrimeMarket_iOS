//
//  ExtensionUILabel.swift
//  SMarket
//
//  Created by Mac-00016 on 15/11/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "")
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
extension UILabel {
    class MyTapGestureRecognizer: UITapGestureRecognizer {
        var headline: String?
        var title: String?
    }
    
    func addTrailingReadMore(with trailingText: String, alertTitle: String, moreText: String, moreTextColor: UIColor, maxLines : Int){
        
        guard self.calculateMaxLines() > maxLines else {
            return
        }
        
        let maxChar = 50 * maxLines
        
        guard let strText = self.text, strText.count > maxChar else {
            return
        }
        let readMoreText: String = trailingText + moreText
        
        let readMoreGesture = MyTapGestureRecognizer(target: self, action:#selector(showViewMore(_:)))
        readMoreGesture.numberOfTapsRequired = 1
        readMoreGesture.headline = strText
        readMoreGesture.title = alertTitle
        self.addGestureRecognizer(readMoreGesture)
        self.isUserInteractionEnabled = true
        
        let lengthForVisibleString: Int = maxChar
        let mutableString: String = strText
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: (strText.count - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: self.font,
                                                                                          NSAttributedString.Key.foregroundColor: moreTextColor,
                                                                                          NSAttributedString.Key.underlineStyle : 1,
                                                                                          NSAttributedString.Key.underlineColor : moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    
    @objc func showViewMore(_ sender: MyTapGestureRecognizer) {
        
        let text = sender.headline
        let title = sender.title
        
        CTopMostViewController?.presentAlertViewWithOneButton(alertTitle: title, alertMessage: text, btnOneTitle: CBtnClose, btnOneTapped: nil)
    }
    
    func getSeparatedLines() -> [Any] {
        if self.lineBreakMode != NSLineBreakMode.byWordWrapping {
            self.lineBreakMode = .byWordWrapping
        }
        var lines = [Any]() /* capacity: 10 */
        let wordSeparators = CharacterSet.whitespacesAndNewlines
        var currentLine: String? = self.text
        let textLength: Int = (self.text?.count ?? 0)
        var rCurrentLine = NSRange(location: 0, length: textLength)
        var rWhitespace = NSRange(location: 0, length: 0)
        var rRemainingText = NSRange(location: 0, length: textLength)
        var done: Bool = false
        while !done {
            // determine the next whitespace word separator position
            rWhitespace.location = rWhitespace.location + rWhitespace.length
            rWhitespace.length = textLength - rWhitespace.location
            rWhitespace = (self.text! as NSString).rangeOfCharacter(from: wordSeparators, options: .caseInsensitive, range: rWhitespace)
            if rWhitespace.location == NSNotFound {
                rWhitespace.location = textLength
                done = true
            }
            let rTest = NSRange(location: rRemainingText.location, length: rWhitespace.location - rRemainingText.location)
            let textTest: String = (self.text! as NSString).substring(with: rTest)
            let fontAttributes: [String: Any]? = [NSAttributedString.Key.font.rawValue: font]
            let maxWidth = (textTest as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
            if maxWidth > self.bounds.size.width  {
                lines.append(currentLine?.trimmingCharacters(in: wordSeparators) ?? "")
                rRemainingText.location = rCurrentLine.location + rCurrentLine.length
                rRemainingText.length = textLength - rRemainingText.location
                continue
            }
            rCurrentLine = rTest
            currentLine = textTest
        }
        let rTest = NSRange(location: rRemainingText.location, length: rWhitespace.location - rRemainingText.location)
        let textTest: String = (self.text! as NSString).substring(with: rTest)
        lines.append(textTest.trimmingCharacters(in: wordSeparators))
        return lines
    }
    
    var lastLineWidth: CGFloat {
        let lines: [Any] = self.getSeparatedLines()
        if !lines.isEmpty {
            let lastLine: String = (lines.last as? String)!
            let fontAttributes = [NSAttributedString.Key.font.rawValue: font]
            return (lastLine as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
        }
        return 0
    }
    var secondLineWidth: CGFloat {
        let lines: [Any] = self.getSeparatedLines()
        if !lines.isEmpty && lines.count > 1 {
            let lastLine: String = (lines[1] as? String)!
            let fontAttributes = [NSAttributedString.Key.font.rawValue: font]
            return (lastLine as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
        }
        if !lines.isEmpty && lines.count == 1 {
            let lastLine: String = (lines[0] as? String)!
            let fontAttributes = [NSAttributedString.Key.font.rawValue: font]
            return (lastLine as NSString).size(withAttributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]).width
        }
        return 0
    }
}

