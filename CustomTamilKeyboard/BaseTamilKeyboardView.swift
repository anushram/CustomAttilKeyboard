//
//  BaseTamilKeyboardView.swift
//  CustomTamilKeyboard
//
//  Created by Ramkumar J on 26/05/23.
//

import Foundation
import UIKit

protocol iLLAGUKeyboardDelegate{
    func didEnteredText(text: String)
    func deleteTextBackWord()
    func changeLanguage(lanCode: SelectedLanguage, keyboardView: UIView, from: SelectedLanguage)
    func doneAction()
    func closeAction()
}

class EnglishKeyboard: UIView {
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var worldBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var isCapitalTag: Bool = false{
        didSet{
            buttons =  buttons.map { (button) in
                let title = englishsmallLetters[button.tag]
                button.setTitle(isCapitalTag ? title.capitalized : title, for: .normal)
                return button
            }
        }
    }
    
    override func awakeFromNib() {
        isCapitalTag = false
        self.setImagesForPriorVersions()
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    var keyboardDelegate: iLLAGUKeyboardDelegate?
    
    class func instanceFromNib() -> EnglishKeyboard {
        let bundle = Bundle(for: EnglishKeyboard.self)
        return UINib(nibName: String(describing: EnglishKeyboard.self), bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! EnglishKeyboard
    }
    
    @IBAction func wordClickAction(sender: UIButton){
        let letter = englishsmallLetters[sender.tag]
        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
            sender.superview?.transform = .identity
            self.keyboardDelegate?.didEnteredText(text: (self.isCapitalTag ? capitalEnglishUnicode[letter] : smallEnglishUnicode[letter]) ?? "")
        }, completion: nil)
    }
    
    @IBAction func deleteBackward(sender: UIButton){
        keyboardDelegate?.deleteTextBackWord()
    }
    
    @IBAction func changeLanguage(sender: UIButton){
        keyboardDelegate?.changeLanguage(lanCode: .ta, keyboardView: self, from: .en)
    }
    
    @IBAction func changeCapitalized(sender: UIButton){
        isCapitalTag = !isCapitalTag
    }
    
    @IBAction func doneAction(sender: UIButton){
        keyboardDelegate?.doneAction()
    }
    
    @IBAction func closeAction(sender: UIButton){
        keyboardDelegate?.closeAction()
    }
    
    @IBAction func space(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kSpace)
    }
    
    @IBAction func changeSpecialKeyboard(sender: UIButton){
        keyboardDelegate?.changeLanguage(lanCode: .sl, keyboardView: self, from: .en)
    }
    
    private func setImagesForPriorVersions(){
        if #unavailable(iOS 14) {
            worldBtn.setImage(UIImage.kWorld, for: .normal)
            deleteBtn.setImage(UIImage.kBackClear, for: .normal)
        }
    }
    
}

class BaseTamilView: UIView{
    
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var keyboardDelegate: iLLAGUKeyboardDelegate?
    
    @IBOutlet weak var worldBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var inputTextField: UITextField? = nil{
        didSet{
            reloadMeiEzhuthu()
            reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
        }
    }
    var inputTextView: UITextView? = nil{
        didSet{
            reloadMeiEzhuthu()
            reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
        }
    }
    
    @IBOutlet var uzirEzhuthuButtons: [UIButton]! {
        didSet {
            uzirEzhuthuButtons.forEach { button in
                button.titleLabel?.numberOfLines = 1;
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.titleLabel?.lineBreakMode = .byClipping
            }
        }
    }
    @IBOutlet var meiEzhuthuButtons: [UIButton]!
    
    var isUirEzhuthuChanged = false
    
    override func awakeFromNib() {
        setImagesForPriorVersions()
    }
    
    class func instanceFromNib() -> BaseTamilView {
        let bundle = Bundle(for: BaseTamilView.self)
        return UINib(nibName: String(describing: BaseTamilView.self), bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! BaseTamilView
    }
    
    @IBAction func didTabMeiEzhuthu(sender: UIButton){
        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
            sender.superview?.transform = .identity
            self.keyboardDelegate?.didEnteredText(text: meiEzhuthu[sender.tag])
            self.isUirEzhuthuChanged = true
            self.reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged, meiEzhuthu: meiEzhuthu[sender.tag])
        }, completion: nil)
    }
    
    @IBAction func didTabUirEzhuthu(sender: UIButton){
        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
            sender.superview?.transform = .identity
                self.changeUirEzhuthu(index: sender.tag, isUirEzhuthu: self.isUirEzhuthuChanged)
        }, completion: nil)
    }
    
    private func reloadUirEzhuthu(isUirEzhuthu: Bool, meiEzhuthu: String = "") {
        uzirEzhuthuButtons = uzirEzhuthuButtons.enumerated().map { (index,button) in
            button.tag = index
            let title = self.isUirEzhuthuChanged ? "\(meiEzhuthu)\(uyirMeiEzhuthuUnicode[index])" : uyirEzhuthu[index]
            button.setTitle(title, for: .normal)
            return button
        }
    }
    
    private func reloadMeiEzhuthu() {
        meiEzhuthuButtons = meiEzhuthuButtons.enumerated().map { (index, button) in
            button.tag = index
            let title = meiEzhuthu[index]
            button.setTitle(title, for: .normal)
            return button
        }
    }
    
    private func changeUirEzhuthu(index: Int, isUirEzhuthu: Bool) {
        if !isUirEzhuthu {
            keyboardDelegate?.didEnteredText(text: uyirEzhuthu[index])
            reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
        }else{
            self.isUirEzhuthuChanged = false
            keyboardDelegate?.didEnteredText(text: uyirMeiEzhuthuUnicode[index])
            reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
        }
    }
    
    @IBAction func backWord(sender: UIButton){
        //Check if text two unicode like கஂ
        if let input = inputTextField {
            if let text = input.text{
                if text.count > 0{
                    reloadBackWord(text: text)
                }
            }
        }else if let input = inputTextView {
            if let text = input.text{
                if text.count > 0{
                    reloadBackWord(text: text)
                }
            }
        }
    }
    
    private func reloadBackWord(text: String){
        if text.count > 0{
            if (text.last?.unicodeScalars.count)! > 1{
                //Check
                if let lastChar = text.last?.unicodeScalars.last{
                    if uyirMeiEzhuthuUnicode.contains(String(lastChar)){
                        if let txt = text.last!.unicodeScalars.first{
                            isUirEzhuthuChanged = true
                            reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged, meiEzhuthu: String(txt))
                        }
                    }else{
                        isUirEzhuthuChanged = false
                        reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
                    }
                }
            }else{
                self.isUirEzhuthuChanged = false
                reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
            }
            self.keyboardDelegate?.deleteTextBackWord()
        }
    }
    
    @IBAction func space(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kSpace)
    }
    
    @IBAction func changeLanguage(sender: UIButton){
        keyboardDelegate?.changeLanguage(lanCode: .en, keyboardView: self, from: .ta)
    }
    @IBAction func doneAction(sender: UIButton){
        keyboardDelegate?.doneAction()
    }
    
    @IBAction func closeAction(sender: UIButton){
        keyboardDelegate?.closeAction()
    }
    
    @IBAction func changeUyirEzhuthu(sender: UIButton){
        self.isUirEzhuthuChanged = false
        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
            sender.superview?.transform = .identity
                self.reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
        }, completion: nil)
    }
    
    @IBAction func changeSpecialKeyboard(sender: UIButton){
        keyboardDelegate?.changeLanguage(lanCode: .sl, keyboardView: self, from: .ta)
    }
    
    @IBAction func ayuthaEzhuthu(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kAyuthaEzhuthu)
    }
    
    @IBAction func dotTap(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kDot)
    }
    
    private func setImagesForPriorVersions(){
        if #unavailable(iOS 14) {
            returnBtn.setImage(UIImage.kReturn, for: .normal)
            worldBtn.setImage(UIImage.kWorld, for: .normal)
            deleteBtn.setImage(UIImage.kBackClear, for: .normal)
        }
    }
}

class SpecialCharactersKeyboard: UIView{
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var worldBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var keyboardDelegate: iLLAGUKeyboardDelegate?
    
    @IBOutlet weak var specialChars: UIButton!
    
    var selectedLanguage: SelectedLanguage = .en{
        didSet{
            worldBtn.setTitle(selectedLanguage == .en ? Constants.kEnglishTitle : Constants.kTamilTitle, for: .normal)
        }
    }
    
    var isAdditionalChars = false{
        didSet{
            specialCharButtons =  specialCharButtons.map { (button) in
                let title = isAdditionalChars ? passwordSpecialChars[button.tag] : additionalSpecialChars[button.tag]
                button.setTitle(title, for: .normal)
                return button
            }
            specialChars.setTitle(isAdditionalChars ? Constants.kSpecialCharTitle : Constants.kNumberTitle, for: .normal)
        }
    }
    
    @IBOutlet var specialCharButtons: [UIButton]!
    
    class func instanceFromNib() -> SpecialCharactersKeyboard {
        let bundle = Bundle(for: SpecialCharactersKeyboard.self)
        return UINib(nibName: String(describing: SpecialCharactersKeyboard.self), bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! SpecialCharactersKeyboard
    }
    
    override func awakeFromNib() {
        isAdditionalChars = true
        self.setImagesForPriorVersions()
        print(selectedLanguage)
        
    }
    
    @IBAction func changeLanguage(sender: UIButton){
        keyboardDelegate?.changeLanguage(lanCode: selectedLanguage, keyboardView: self, from: .sl)
    }
    @IBAction func doneAction(sender: UIButton){
        keyboardDelegate?.doneAction()
    }
    
    @IBAction func closeAction(sender: UIButton){
        keyboardDelegate?.closeAction()
    }
    
    @IBAction func deleteBackward(sender: UIButton){
        keyboardDelegate?.deleteTextBackWord()
    }
    
    @IBAction func wordClickAction(sender: UIButton){
        let title = isAdditionalChars ? passwordSpecialChars[sender.tag] : additionalSpecialChars[sender.tag]
        let letter = isAdditionalChars ? passwordSpecialUnicodeChars[title]  : additionalSpecialUnicodeChars[title]
        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
            sender.superview?.transform = .identity
            self.keyboardDelegate?.didEnteredText(text: letter!)
        }, completion: nil)
    }
    
    @IBAction func wordexclamationAction(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kExclamation)
    }
    
    @IBAction func changeSpecialChars(sender: UIButton){
        isAdditionalChars = !isAdditionalChars
    }
    
    private func setImagesForPriorVersions(){
        if #unavailable(iOS 14) {
            worldBtn.setImage(UIImage.kWorld, for: .normal)
            deleteBtn.setImage(UIImage.kBackClear, for: .normal)
        }
    }
    
}
