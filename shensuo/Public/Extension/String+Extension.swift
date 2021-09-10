//
//  String+Extension.swift
//  MuslimUmmah
//
//  Created by RSY on 2019/6/17.
//  Copyright © 2019 com.advance. All rights reserved.
//

import Foundation

extension String {
    
    /// "" 即为空
    var X: String? {
        return self == "" ? nil : self
    }
    
    /// 字符串本地化
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// 数字符号化
    var intSymbolic: String {
        guard let i = Int(self) else { return self }
        var d = Double(i)
        switch d {
        case 0..<1E3:
            return "\(i)"
        case 1E3..<1E6:
            d = (d/1E2).rounded()
            let i = Int(d)
            return i%10 == 0 ? "\(i/10)K" : "\(d/10.0)k"
        case 1E6..<1E9:
            d = (d/1E5).rounded()
            let i = Int(d)
            return i%10 == 0 ? "\(i/10)M" : "\(d/10.0)m"
        case 1E9..<1E12:
            d = (d/1E8).rounded()
            let i = Int(d)
            return i%10 == 0 ? "\(i/10)G" : "\(d/10.0)g"
        case 1E12...:
            var n: Int = 2
            repeat {
                d /= 10
                n += 1
            } while d > 1E3
            d = d.rounded()
            return "\(d/1E2)E\(n)"
        default:
            return self
        }
    }
    
    static func pluralityExpression(by number: Int, suffix: String, pluralSuffix: String, nonNegative: Bool = true) -> String {
        if number < 0 {
            if nonNegative {
                return "0 \(suffix)"
            } else {
                return "\(number) \(suffix)"
            }
        } else if number == 0 {
            return "0 \(suffix)"
        } else if number == 1 {
            return "\(number) \(suffix)"
        } else {
            return "\(number) \(pluralSuffix)"
        }
    }
}

extension String {
    
    /// Remove redundant line break signs at the beginning and the end.
    ///
    /// If the string starts with two line break signs ("\n\n"), remove one
    /// of them.
    ///
    /// So is it with the end of the string.
    mutating func shrinkLineBreakForContent() {
        if hasPrefix("\n\n") { removeFirst() }
        if hasSuffix("\n\n") { removeLast () }
    }
    
    /// Remove all line break signs and white spaces at the beginning and the end.
    mutating func stripLineBreakForContent() {
        self = trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Calculate the height according to given font and width.
    ///
    /// The calculation is not precise. So to compare the result with any text container's
    /// actual height, the proper way is to see if their difference is in a tolerable threshold.
    func heightIfFullyRendered(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}



extension String {
    //to double
    public func toDouble(_ minDig: Int = 0, _ maxDig: Int = 9) -> Double {
        var doubleValue : Double = 0.0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = minDig
        numberFormatter.maximumFractionDigits = maxDig
        let finalNumber = numberFormatter.number(from: self)
        doubleValue = (finalNumber?.doubleValue)!;
        return doubleValue
    }
}


extension String {
    
    var intValue: Int? {
        return Int(self)
    }
    
    var floatValue: Float? {
        return Float(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
}
