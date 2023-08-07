//
//  CommonFile.swift
//  CustomTamilKeyboard
//
//  Created by Ramkumar J on 27/05/23.
//

import Foundation
import UIKit
import CoreData
//Shadow Class reused all throughout this app.
@IBDesignable
class ShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        DrawShadows()
    }
    override var bounds: CGRect { didSet { DrawShadows() } }
    @IBInspectable var cornerRadius: Float = 10 { didSet { DrawShadows() } }
    @IBInspectable var iPadcornerRadius: Float = 10
    @IBInspectable var ShadowOpacity: Float = 0 { didSet { DrawShadows() } }
    @IBInspectable var ShadowRadius: Float = 1.75 { didSet { DrawShadows() } }
    @IBInspectable var ShadowColor: UIColor = UIColor.black { didSet { DrawShadows() } }
    @IBInspectable var borderWidth: Float = 0.0 { didSet { DrawShadows() }}
    @IBInspectable var borderColor: UIColor = UIColor.black { didSet { DrawShadows() } }
    @IBInspectable var maskToBounds: Int = -1 { didSet { DrawShadows() } }
    
    func DrawShadows() {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = ShadowColor.cgColor
        self.layer.shadowOpacity = ShadowOpacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = CGFloat(ShadowRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        if maskToBounds != -1 {
            self.layer.masksToBounds = maskToBounds == 1
            //self.layer.masksToBounds = false
        } else {
            self.layer.masksToBounds = false
        }
        let rect = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 2)
        self.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath
        
    }
}

let meiEzhuthuExtra = ["க": "\u{0B95}", "ங": "\u{0B99}", "ச": "\u{0B9A}", "ஞ": "\u{0B9E}", "ட": "\u{0B9F}", "ண": "\u{0BA3}","த": "\u{0BA4}", "ந": "\u{0BA8}", "ப": "\u{0BAA}", "ம": "\u{0BAE}", "ய": "\u{0BAF}", "ர": "\u{0BB0}","ல": "\u{0BB2}", "வ": "\u{0BB5}", "ழ": "\u{0BB4}", "ள": "\u{0BB3}", "ற": "\u{0BB1}", "ன": "\u{0BA9}", "ஷ": "\u{0BB7}", "ஸ": "\u{0BB8}", "ஜ": "\u{0B9C}", "ஹ": "\u{0BB9}", "க்ஷ": "\u{0B95}\u{0BCD}\u{0BB7}"]

let meiEzhuthu = ["\u{0B95}", "\u{0B99}","\u{0B9A}","\u{0B9E}","\u{0B9F}","\u{0BA3}","\u{0BA4}", "\u{0BA8}","\u{0BAA}","\u{0BAE}","\u{0BAF}","\u{0BB0}","\u{0BB2}","\u{0BB5}","\u{0BB4}", "\u{0BB3}","\u{0BB1}","\u{0BA9}","\u{0BB7}","\u{0BB8}", "\u{0B9C}","\u{0BB9}","\u{0B95}\u{0BCD}\u{0BB7}"]

let uyirEzhuthuDetails = ["அ": "\u{0B85}", "ஆ": "\u{0B86}", "இ": "\u{0B87}", "ஈ": "\u{0B88}","உ": "\u{0B89}", "ஊ": "\u{0B8A}", "எ": "\u{0B8E}", "ஏ": "\u{0B8F}", "ஐ": "\u{0B90}", "ஒ": "\u{0B92}", "ஓ": "\u{0B93}", "ஔ": "\u{0B94}"] as [String: AnyObject]

let uyirEzhuthu = ["\u{0B85}","\u{0B86}","\u{0B87}","\u{0B88}","\u{0B89}", "\u{0B8A}","\u{0B8E}","\u{0B8F}","\u{0B90}","\u{0B92}","\u{0B93}","\u{0B94}"]
let uyirMeiEzhuthuUnicode = ["\u{0BCD}","\u{0BBE}","\u{0BBF}","\u{0BC0}","\u{0BC1}","\u{0BC2}","\u{0BC6}","\u{0BC7}","\u{0BC8}","\u{0BCA}","\u{0BCB}","\u{0BCC}"]

let smallEnglishUnicode = ["z":"\u{007A}","x":"\u{0078}","c":"\u{0063}","v":"\u{0076}","b":"\u{0062}","n":"\u{006E}","m":"\u{006D}", "a":"\u{0061}","s":"\u{0073}","d":"\u{0064}","f":"\u{0066}","g":"\u{0067}","h":"\u{0068}","j":"\u{006A}","k":"\u{006B}","l":"\u{006C}","q":"\u{0071}", "w":"\u{0077}","e":"\u{0065}","r":"\u{0072}","t":"\u{0074}","y":"\u{0079}","u":"\u{0075}","i":"\u{0069}","o":"\u{006F}","p":"\u{0070}"]

let capitalEnglishUnicode = ["z":"\u{005A}","x":"\u{0058}","c":"\u{0043}","v":"\u{0056}","b":"\u{0042}","n":"\u{004E}","m":"\u{004D}", "a":"\u{0041}","s":"\u{0053}","d":"\u{0044}","f":"\u{0046}","g":"\u{0047}","h":"\u{0048}","j":"\u{004A}","k":"\u{004B}","l":"\u{004C}","q":"\u{0051}", "w":"\u{0057}","e":"\u{0045}","r":"\u{0052}","t":"\u{0054}","y":"\u{0059}","u":"\u{0055}","i":"\u{0049}","o":"\u{004F}","p":"\u{0050}"]
let englishsmallLetters = ["z","x","c","v","b","n","m","a","s","d","f","g","h","j","k","l","q","w","e","r","t","y","u","i","o","p"]
let passwordSpecialChars = ["-","/",":",";","(",")","₹","&","@","“","1","2","3","4","5","6","7","8","9","0"]
let passwordSpecialUnicodeChars = ["-": "\u{002D}" ,"/":"\u{002F}",":": "\u{003A}",";": "\u{003B}","(": "\u{0028}",")": "\u{0029}","₹": "\u{0029}","&": "\u{0026}","@": "\u{0040}","“": "\u{0022}","1":"\u{0031}","2": "\u{0032}","3": "\u{0033}","4": "\u{0034}","5": "\u{0035}","6": "\u{0036}","7": "\u{0037}","8": "\u{0038}","9": "\u{0039}","0": "\u{0030}"]
let additionalSpecialChars = ["_","\\","|","~","<",">","$","&","@","€","[","]","{","}","#","%","^","*","+","="]
let additionalSpecialUnicodeChars = ["_": "\u{005F}","\\": "\u{005C}","|": "\u{007C}","~": "\u{007E}","<": "\u{003C}",">": "\u{003E}","$": "\u{0024}","&": "\u{0026}","@": "\u{0040}","€": "\u{20AC}","[": "\u{005B}","]": "\u{005D}","{": "\u{007B}","}": "\u{007D}","#": "\u{0023}","%": "\u{0025}","^": "\u{005E}","*": "\u{002A}","+": "\u{002B}","=": "\u{0023}"]

enum SelectedLanguage: String{
    case ta, en, sl
}

class Constants{
    static let kEnglishTitle = "ABC"
    static let kTamilTitle = "தமிழ்"
    static let kSpecialCharTitle = "#+="
    static let kNumberTitle = "123"
}

extension String{
    static let kExclamation = "\u{0021}"
    static let kDot = "\u{00B7}"
    static let kAyuthaEzhuthu = "\u{0B83}"
    static let kSpace = "\u{0020}"
    static let kLanguage = "en"
    static let kNextLine = "\u{0085}"
}

extension UIImage{
    static let kReturn = UIImage.init(named: "return")
    static let kWorld = UIImage.init(named: "world")
    static let kBackClear = UIImage.init(named: "backclear")
}
