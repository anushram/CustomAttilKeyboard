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

enum SwithchCaps: Int {
    case singleCap
    case doubleCap
    case none
}

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
            configure()
    }
    
    func configure() {
        if #available(iOS 15.0, *) {
            self.configuration = .filled()
            self.configuration?.buttonSize = .large
            self.configuration?.baseBackgroundColor = .white
            self.configuration?.titleLineBreakMode = .byClipping
            self.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
        self.titleLabel?.numberOfLines = 1;
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byClipping
    }
    
    var hightLightedTextColor: UIColor = .lightGray
    
    override open var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            if isHighlighted {
                backgroundColor = UIColor.darkGray
                if #available(iOS 15.0, *) {
                    self.configuration?.baseBackgroundColor = .darkGray
                }
            }else {
                backgroundColor = UIColor.white
                if #available(iOS 15.0, *) {
                    self.configuration?.baseBackgroundColor = .white
                }
            }
        }
    }
}

class EnglishKeyboard: UIView {
    
    var timer: Timer?
    
    @IBOutlet weak var deleteBtn: UIButton! {
        didSet {
            deleteBtn.setImage(UIImage(systemName: "delete.left.fill"), for: .highlighted)
            var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteContinuosText(sender:)))
            self.deleteBtn.addGestureRecognizer(longPressRecognizer)
        }
    }
    @IBOutlet weak var worldBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton! {
        didSet {
            doneBtn.setTitleColor(.lightGray, for: .highlighted)
        }
    }
    
    @IBOutlet weak var capBtn: UIButton!
    
    @IBOutlet weak var spaceBtn: UIButton! {
        didSet {
            spaceBtn.setTitleColor(.lightGray, for: .highlighted)
        }
    }
    
    @IBOutlet weak var dotBtn: UIButton! {
        didSet {
            dotBtn.setTitleColor(.lightGray, for: .highlighted)
        }
    }
    
    var switchCap: SwithchCaps = .singleCap
    
    var isCapitalTag: Bool = true{
        didSet{
            buttons =  buttons.map { (button) in
                let title = englishsmallLetters[button.tag]
                UIView.performWithoutAnimation {
                    button.setTitle(isCapitalTag ? title.capitalized : title, for: .normal)
                }
                return button
            }
        }
    }
    
    override func awakeFromNib() {
        isCapitalTag = true
        self.setImagesForPriorVersions()
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeSingleCapitalized(sender:)))
        singleTapGesture.numberOfTapsRequired = 1
        capBtn.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeDoubleCapitalized(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        capBtn.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @IBOutlet var buttons: [CustomButton]! {
        didSet {
            buttons.forEach { button in
                button.showsTouchWhenHighlighted = true
                //button.setTitleColor(.lightGray, for: .highlighted)
            }
        }
    }
    
    var keyboardDelegate: iLLAGUKeyboardDelegate?
    
    class func instanceFromNib() -> EnglishKeyboard {
        let bundle = Bundle(for: EnglishKeyboard.self)
        return UINib(nibName: String(describing: EnglishKeyboard.self), bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! EnglishKeyboard
    }
    
    @IBAction func wordClickAction(sender: UIButton){
        let letter = englishsmallLetters[sender.tag]
        //        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        //        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
        //            sender.superview?.transform = .identity
        //            self.keyboardDelegate?.didEnteredText(text: (self.isCapitalTag ? capitalEnglishUnicode[letter] : smallEnglishUnicode[letter]) ?? "")
        //        }, completion: {_ in
        //            if self.switchCap == .singleCap {
        //                self.switchCap = .none
        //                self.isCapitalTag = false
        //                self.capBtn.setImage(UIImage(systemName: "arrowshape.up"), for: .normal)
        //            }
        //        })
        self.keyboardDelegate?.didEnteredText(text: (self.isCapitalTag ? capitalEnglishUnicode[letter] : smallEnglishUnicode[letter]) ?? "")
        if self.switchCap == .singleCap {
            self.switchCap = .none
            self.isCapitalTag = false
            self.capBtn.setImage(UIImage(systemName: "arrowshape.up"), for: .normal)
        }
    }
    
    @IBAction func deleteBackward(sender: UIButton){
        keyboardDelegate?.deleteTextBackWord()
    }
    
    @IBAction func changeLanguage(sender: UIButton){
        keyboardDelegate?.changeLanguage(lanCode: .ta, keyboardView: self, from: .en)
    }
    
    @objc func changeSingleCapitalized(sender: UITapGestureRecognizer){
        if self.switchCap == .doubleCap || self.switchCap == .singleCap {
            isCapitalTag = false
            self.switchCap = .none
            //arrowshape.up
            self.capBtn.setImage(UIImage(systemName: "arrowshape.up"), for: .normal)
        }else if self.switchCap == .none {
            isCapitalTag = true
            self.switchCap = .singleCap
            self.capBtn.setImage(UIImage(systemName: "arrowshape.up.fill"), for: .normal)
        }
    }
    
    @IBAction func dotAction(sender: UIButton) {
        self.keyboardDelegate?.didEnteredText(text: String.kDot)
    }
    
    
    @objc func changeDoubleCapitalized(sender: UITapGestureRecognizer){
        self.switchCap = .doubleCap
        isCapitalTag = true
        self.capBtn.setImage(UIImage(systemName: "capslock.fill"), for: .normal)
    }
    
    @objc func deleteContinuosText(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer(timer:)), userInfo: nil, repeats: true)
            } else if sender.state == .ended || sender.state == .cancelled {
                timer?.invalidate()
                timer = nil
            }
    }
    
    @objc func handleTimer(timer: Timer) {
        keyboardDelegate?.deleteTextBackWord()
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
    
    var timer: Timer?
    
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton! {
        didSet {
            deleteBtn.setImage(UIImage(systemName: "delete.left.fill"), for: .highlighted)
            var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteContinuosText(sender:)))
            self.deleteBtn.addGestureRecognizer(longPressRecognizer)
        }
    }
    
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
    
    @IBOutlet var uzirEzhuthuButtons: [CustomButton]! {
        didSet {
            uzirEzhuthuButtons.forEach { button in
//                button.titleLabel?.numberOfLines = 1;
//                button.titleLabel?.adjustsFontSizeToFitWidth = true
//                button.titleLabel?.lineBreakMode = .byClipping
//                button.setTitleColor(.lightGray, for: .highlighted)
            }
        }
    }
    @IBOutlet var meiEzhuthuButtons: [CustomButton]! {
        didSet {
            meiEzhuthuButtons.forEach { button in
//                button.titleLabel?.numberOfLines = 0;
//                button.titleLabel?.adjustsFontSizeToFitWidth = true
//                button.titleLabel?.lineBreakMode = .byClipping
//                button.sizeToFit()
//                button.titleLabel?.adjustsFontSizeToFitWidth = true
            }
        }
    }
    
    var isUirEzhuthuChanged = false
    
    override func awakeFromNib() {
        setImagesForPriorVersions()
//        addCursorChangeObserver()
    }
    
    class func instanceFromNib() -> BaseTamilView {
        let bundle = Bundle(for: BaseTamilView.self)
        return UINib(nibName: String(describing: BaseTamilView.self), bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! BaseTamilView
    }
    
    func addCursorChangeObserver(){
        inputTextField?.addObserver(self, forKeyPath: "selectedTextRange", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedTextRange" && inputTextField == object as? UITextField{
            print("Yes")
            guard let selectedRange = inputTextField?.selectedTextRange else {return}
            if let lastChar = inputTextField?.getTextFromRange(textRange: selectedRange)?.unicodeScalars.last{
                if uyirMeiEzhuthuUnicode.contains(String(lastChar)){
                   // if let txt = text.last!.unicodeScalars.first{
                    if let txt = inputTextField?.getTextFromRange(textRange: selectedRange, offSet: -2)?.unicodeScalars.first{
                        if meiEzhuthu.contains(String(txt)){
                            isUirEzhuthuChanged = false
                            reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
                        }
                    }
                }else if meiEzhuthu.contains(String(lastChar)) {
                    isUirEzhuthuChanged = true
                    reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged, meiEzhuthu: String(String(lastChar)))
                }else{
                    isUirEzhuthuChanged = false
                    reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
                }
            }else{
                self.isUirEzhuthuChanged = false
                reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
            }
        }
    }
    
    @IBAction func didTabMeiEzhuthu(sender: UIButton){
        /*
         sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
         sender.superview?.transform = .identity
         self.keyboardDelegate?.didEnteredText(text: meiEzhuthu[sender.tag])
         self.isUirEzhuthuChanged = true
         self.reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged, meiEzhuthu: meiEzhuthu[sender.tag])
         }, completion: nil)
         */
        self.keyboardDelegate?.didEnteredText(text: meiEzhuthu[sender.tag])
        self.isUirEzhuthuChanged = true
        self.reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged, meiEzhuthu: meiEzhuthu[sender.tag])
    }
    
    @IBAction func didTabUirEzhuthu(sender: UIButton){
        //        sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        //        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
        //            sender.superview?.transform = .identity
        //                self.changeUirEzhuthu(index: sender.tag, isUirEzhuthu: self.isUirEzhuthuChanged)
        //        }, completion: nil)
        self.changeUirEzhuthu(index: sender.tag, isUirEzhuthu: self.isUirEzhuthuChanged)
    }
    
    private func reloadUirEzhuthu(isUirEzhuthu: Bool, meiEzhuthu: String = "") {
        uzirEzhuthuButtons = uzirEzhuthuButtons.enumerated().map { (index,button) in
            button.tag = index
            let title = self.isUirEzhuthuChanged ? "\(meiEzhuthu)\(uyirMeiEzhuthuUnicode[index])" : uyirEzhuthu[index]
            UIView.performWithoutAnimation {
                button.setTitle(title, for: .normal)
            }
            return button
        }
    }
    
    private func reloadMeiEzhuthu() {
        meiEzhuthuButtons = meiEzhuthuButtons.enumerated().map { (index, button) in
            button.tag = index
            let title = meiEzhuthu[index]
            UIView.performWithoutAnimation {
                button.setTitle(title, for: .normal)
            }
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
    
    @objc func deleteContinuosText(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer(timer:)), userInfo: nil, repeats: true)
            } else if sender.state == .ended || sender.state == .cancelled {
                timer?.invalidate()
                timer = nil
            }
    }
    
    @objc func handleTimer(timer: Timer) {
        self.backWord(sender: self.deleteBtn)
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
            if (text.last?.unicodeScalars.count)! > 0{
                //Check
                guard let selectedRange = inputTextField?.selectedTextRange else {return}
                if let lastChar = inputTextField?.getTextFromRange(textRange: selectedRange)?.unicodeScalars.last{
                    if uyirMeiEzhuthuUnicode.contains(String(lastChar)){
                       // if let txt = text.last!.unicodeScalars.first{
                        if let txt = inputTextField?.getTextFromRange(textRange: selectedRange, offSet: -2)?.unicodeScalars.first{
                            if meiEzhuthu.contains(String(txt)){
                                isUirEzhuthuChanged = true
                                reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged, meiEzhuthu: String(txt))
                            }
                        }
                    }else if meiEzhuthu.contains(String(lastChar)){
                        if let txt = inputTextField?.getTextFromRange(textRange: selectedRange, offSet: -2)?.unicodeScalars.first{
                            if meiEzhuthu.contains(String(txt)){
                                isUirEzhuthuChanged = true
                                reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged, meiEzhuthu: String(txt))
                            }else {
                                isUirEzhuthuChanged = false
                                reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
                            }
                        }else {
                            isUirEzhuthuChanged = false
                            reloadUirEzhuthu(isUirEzhuthu: isUirEzhuthuChanged)
                        }
                        
                    }else {
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
        /*
         self.isUirEzhuthuChanged = false
         sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
         sender.superview?.transform = .identity
         self.reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
         }, completion: nil)
         */
        self.isUirEzhuthuChanged = false
        self.reloadUirEzhuthu(isUirEzhuthu: self.isUirEzhuthuChanged)
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
    
    var timer: Timer?
    
    @IBOutlet weak var deleteBtn: UIButton! {
        didSet {
            deleteBtn.setImage(UIImage(systemName: "delete.left.fill"), for: .highlighted)
            var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteContinuosText(sender:)))
            self.deleteBtn.addGestureRecognizer(longPressRecognizer)
        }
    }
    @IBOutlet weak var worldBtn: UIButton!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    var keyboardDelegate: iLLAGUKeyboardDelegate?
    
    @IBOutlet weak var specialChars: UIButton!
    
    @IBOutlet weak var spaceBtn: UIButton! {
        didSet {
            spaceBtn.setTitleColor(.lightGray, for: .highlighted)
        }
    }
    
    var selectedLanguage: SelectedLanguage = .en{
        didSet{
            worldBtn.setTitle(selectedLanguage == .en ? Constants.kEnglishTitle : Constants.kTamilTitle, for: .normal)
        }
    }
    
    var isAdditionalChars = false{
        didSet{
            specialCharButtons =  specialCharButtons.map { (button) in
                let title = isAdditionalChars ? passwordSpecialChars[button.tag] : additionalSpecialChars[button.tag]
                UIView.performWithoutAnimation {
                    button.setTitle(title, for: .normal)
                }
                return button
            }
            specialChars.setTitle(isAdditionalChars ? Constants.kSpecialCharTitle : Constants.kNumberTitle, for: .normal)
        }
    }
    
    @IBOutlet var specialCharButtons: [UIButton]! {
        didSet {
            for (index, button) in specialCharButtons.enumerated() {
                button.tag = index
                button.showsTouchWhenHighlighted = true
                button.setTitleColor(.lightGray, for: .highlighted)
            }
        }
    }
    
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
    
    @objc func deleteContinuosText(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleTimer(timer:)), userInfo: nil, repeats: true)
            } else if sender.state == .ended || sender.state == .cancelled {
                timer?.invalidate()
                timer = nil
            }
    }
    
    @objc func handleTimer(timer: Timer) {
        keyboardDelegate?.deleteTextBackWord()
    }
    
    @IBAction func wordClickAction(sender: UIButton){
        /*
         let title = isAdditionalChars ? passwordSpecialChars[sender.tag] : additionalSpecialChars[sender.tag]
         let letter = isAdditionalChars ? passwordSpecialUnicodeChars[title]  : additionalSpecialUnicodeChars[title]
         sender.superview?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
         sender.superview?.transform = .identity
         self.keyboardDelegate?.didEnteredText(text: letter!)
         }, completion: nil)
         */
        
        let title = isAdditionalChars ? passwordSpecialChars[sender.tag] : additionalSpecialChars[sender.tag]
        let letter = isAdditionalChars ? passwordSpecialUnicodeChars[title]  : additionalSpecialUnicodeChars[title]
        self.keyboardDelegate?.didEnteredText(text: letter!)
    }
    
    @IBAction func wordexclamationAction(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kExclamation)
    }
    
    @IBAction func changeSpecialChars(sender: UIButton){
        isAdditionalChars = !isAdditionalChars
    }
    
    @IBAction func space(sender: UIButton){
        keyboardDelegate?.didEnteredText(text: String.kSpace)
    }
    
    private func setImagesForPriorVersions(){
        if #unavailable(iOS 14) {
            worldBtn.setImage(UIImage.kWorld, for: .normal)
            deleteBtn.setImage(UIImage.kBackClear, for: .normal)
        }
    }
    
}
extension UITextField {
    func getTextFromRange(textRange: UITextRange, offSet: Int = -1) -> String?{
        guard let newPosition = self.position(from: (textRange.start), offset: offSet) else {return nil}
        guard let newRange = self.textRange(from: newPosition, to: textRange.start) else {return nil}
        return self.text(in: newRange)
    }
    func getNewRangeToReplaceText(textRange: UITextRange, offSet: Int = -1) -> UITextRange? {
        guard let newPosition = self.position(from: textRange.start, offset: offSet) else {return nil}
        guard let newRange = self.textRange(from: newPosition, to: textRange.start) else {return nil}
        return newRange
    }
}
