//
//  ExtensionString.swift
//  Master
//
//  Created by Mac-00014 on 06/06/18.
//  Copyright © 2018 MindInventory. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension of String For Converting it TO Int AND URL.
extension String {
    
    /// A Computed Property (only getter) of Int For getting the Int? value from String.
    /// This Computed Property (only getter) returns Int? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toFloat:Float? {
        return Float(self)
    }
    
    
    /// A Computed Property (only getter) of URL For getting the URL from String.
    /// This Computed Property (only getter) returns URL? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("URL!") then application will crash.
    var toURL:URL? {
        return URL(string: self)
    }
    
}

extension String {
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
          return self.filter {okayChars.contains($0) }
      }
    
    var trim:String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isBlank:Bool {
        return self.trim.isEmpty
    }
    
    var isAlphanumeric:Bool {
        return !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
    }
    
    var isValidEmail:Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:self.trim)
    }
    
    var isValidPassword:Bool {
        
//        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
//        return predicate.evaluate(with:self)
        
        if self.count < 6 {
            return false
        }else {
            return self.isValidAlphabets
        }
    }
    
    var isValidPhoneNo:Bool {
        
    
        let phoneRegex = "^[0-9]{7,16}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with:self)
    }
    
    var isValidAlphabets:Bool {
        let alphaRegex = "^(?=.*[a-zA-Z]).{1,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaRegex)
        return predicate.evaluate(with:self)
        
    }
    
    var isValidName:Bool {
        
        let alphaRegex = "^[A-Za-z ]{1,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", alphaRegex)
        return predicate.evaluate(with:self)
        
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }}

extension String {
    
    var dateFromString : String {
        
        return self.dateFromString(serverDateFormate, toDateFormate: displayDateFormate)
    }
    
    func dateFromString(_ fromDateFormate : String, toDateFormate : String) -> String {
        
        if let date =  DateFormatter.shared().date(fromString: self, dateFormat:fromDateFormate) {
            
            return DateFormatter.shared().string(fromDate: date, dateFormat: toDateFormate)
        }
        else {
            return self
        }
    }
    func dateFromTimeStamp() -> Date? {
        
        if let unixTimestamp = Double(self) {
            let date = Date(timeIntervalSince1970: unixTimestamp)
            return date
        }
        return nil
    }
    
    func dateFrom(timestamp: String) -> Date? {
        let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
        let stringDate = DateFormatter.shared().string(fromDate: fromDate, dateFormat: "dd MMM, YYYY")
        return DateFormatter.shared().date(fromString: stringDate, dateFormat: "dd MMM, YYYY")
    }
    
    func durationString(duration: String?) -> String? {
        
        
        if let fromDate = duration?.dateFromTimeStamp() {
            
            if Date().isSameDay(date: fromDate){
                
                let time =   DateFormatter.shared().string(fromDate: fromDate , dateFormat:"hh:mm a")
                return time
            }
        }
        
        
        if let timestamp = duration {
            
            let calender:Calendar = Calendar.current as Calendar
            let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
            let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
            let dateComponents = calender.dateComponents(unitFlags, from:fromDate , to: Date())
            
            let years:NSInteger = dateComponents.year!
            let months:NSInteger = dateComponents.month!
            let days:NSInteger = dateComponents.day!
            let hours:NSInteger = dateComponents.hour!
            let minutes:NSInteger = dateComponents.minute!
            
            var durations = "Just Now"
            
            if (years > 0) {
                durations = "\(years) \(years > 1 ? "years" : "year") ago"
            }
            else if (months > 0) {
                durations = "\(months) \(months > 1 ? "months":"month") ago"
            }
            else if (days > 0) {
                durations = "\(days) \(days > 1 ? "days":"day" ) ago"
            }
//            else if (hours > 0) {
//                durations = "1 day ago"
//            }
            else if (hours > 0) {
                durations = "\(hours) \(hours > 1 ? "hours":"hour") ago"
            }
            else if (minutes > 0) {
                durations = "\(minutes) \(minutes > 1 ? "mins":"min") ago"
            }
            
            return durations;
        }
        
        return ""
    }
    
    func durationFromString() -> String? {
        return self.durationString(duration: self)
    }
}

extension String {
    
    func getSize(height:CGFloat , font:UIFont) -> CGFloat {
        
        let bounds = (self as NSString).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return bounds.size.width
    }
}

extension String {
    
    func rangeOf(_ string : String) -> NSRange {
        
        if let range = self.range(of: string) {
            
            let nsRange = NSRange(range, in: self)
            return nsRange
        }
        
        return NSRange()
    }
}

extension String {
    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let UTCDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
}

