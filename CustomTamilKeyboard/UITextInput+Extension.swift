//
//  UITextInput+Extension.swift
//  CustomTamilKeyboard
//
//  Created by Ramkumar J on 01/08/23.
//

import Foundation
import UIKit

extension UITextInput {
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}
