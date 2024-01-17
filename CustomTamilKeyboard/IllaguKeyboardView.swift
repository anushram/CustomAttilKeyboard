//
//  IllaguKeyboardView.swift
//  CustomTamilKeyboard
//
//  Created by Ramkumar J on 05/06/23.
//

import UIKit

open class IllaguKeyboardView: UIView, iLLAGUKeyboardDelegate {

    func closeAction() {
        if self.targetInput is UITextField {
            self.inputTextField?.resignFirstResponder()
        }else if self.targetInput is UITextView {
            self.inputTextView?.resignFirstResponder()
        }
        if let target = self.targetInput{
            onEventReceived?(target)
        }
        
    }
    
    func doneAction() {
        if self.targetInput is UITextField {
            let result = self.inputTextField?.delegate?.textFieldShouldReturn?(inputTextField ?? UITextField()) ?? false
            if result {
                self.inputTextField?.resignFirstResponder()
            }
            return
        }else {
            self.inputTextView?.insertText(String.kNextLine)
            return
        }
    }
    
    func changeLanguage(lanCode: SelectedLanguage, keyboardView: UIView, from: SelectedLanguage) {
        UIView.animate(withDuration: 0.5) {
            print(self.subviews.count)
            for view in keyboardView.subviews {
                view.removeFromSuperview()
                }
            if lanCode == .ta{
                self.setupKeyboardTextView(keyboardView)
            }else if lanCode == .en{
                self.setupEnglishKeyboardTextView(keyboardView)
            }else{
                self.setupSpecialCharsKeyboardTextView(keyboardView, from: from)
            }
        }
        
    }
    
    func didEnteredText(text: String) {
        if let input = inputTextField {
            let range = NSRange.init(location: input.text?.count ?? 0, length: text.count)
            let allow = input.delegate?.textField?(input, shouldChangeCharactersIn: range, replacementString: text) ?? true
            if allow {
                input.insertText(text)
            }
        }else if let input = inputTextView {
            let range = NSRange.init(location: input.text?.count ?? 0, length: text.count)
            let allow = input.delegate?.textView?(input, shouldChangeTextIn: range, replacementText: text) ?? true
            if allow {
                input.insertText(text)
            }
        }
    }
    
    func deleteTextBackWord() {
        if let input = inputTextField {
            guard let range = input.selectedTextRange?.isEmpty == nil ? NSRange.init(location: input.text?.count ?? 0, length: 1) : input.selectedRange else {return}
            let allow = input.delegate?.textField?(input, shouldChangeCharactersIn: range, replacementString: "") ?? true
            if allow {
                input.deleteBackward()
            }
        }else if let input = inputTextView {
            let range = input.selectedTextRange?.isEmpty == nil ? NSRange.init(location: input.text?.count ?? 0, length: 1) : input.selectedRange
            let allow = input.delegate?.textView?(input, shouldChangeTextIn: range, replacementText: "") ?? true
            if allow {
                input.deleteBackward()
            }
        }
        
    }
        
    var targetInput: UIKeyInput?
    var inputTextField: UITextField?
    var inputTextView: UITextView?
    
    var onEventReceived: ((_ targetView: UIKeyInput) -> Void)?
    
    var tamilView: UIView!
    
    public var selectedLanguage: String = String.kLanguage
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public init(frame: CGRect, targetInput: UIKeyInput, inputTextField: UITextField?, inputTextView: UITextView?, language: String) {
        super.init(frame: .zero)
        self.inputTextView = inputTextView
        self.inputTextField = inputTextField
        self.targetInput = targetInput
        selectedLanguage = language
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: type(of: self))
        if let contentView = bundle.loadNibNamed(String(describing: IllaguKeyboardView.self), owner: self, options: nil)?.first as? UIView{
            contentView.backgroundColor = .green
            self.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.fixConstraintsInView(self)
            contentView.fillToSuperView(margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
            setKeyboardBasedOnLanguage(lan: SelectedLanguage.init(rawValue: selectedLanguage) ?? .en, contentView: contentView)
        }
    }
    
    private func setKeyboardBasedOnLanguage(lan: SelectedLanguage, contentView: UIView) {
        switch lan {
        case .en:
            self.setupEnglishKeyboardTextView(contentView)
        case .ta:
            self.setupKeyboardTextView(contentView)
        default:
            setupSpecialCharsKeyboardTextView(contentView, from: lan)
        }
    }
    
    private func setupKeyboardTextView(_ contentView: UIView) {
        let customInputView = BaseTamilView.instanceFromNib()
        customInputView.inputTextField = self.inputTextField
        customInputView.inputTextView = self.inputTextView
        customInputView.keyboardDelegate = self
        self.frame.size.height = (customInputView.frame.size.height + 60)
        tamilView = customInputView
        contentView.addSubview(customInputView)
        customInputView.translatesAutoresizingMaskIntoConstraints = false
        customInputView.fixConstraintsInView(contentView)
        customInputView.fillToSuperView(margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    private func setupEnglishKeyboardTextView(_ contentView: UIView) {
        let customInputView = EnglishKeyboard.instanceFromNib()
        customInputView.keyboardDelegate = self
        self.frame.size.height = (customInputView.frame.size.height + 60)
        contentView.addSubview(customInputView)
        customInputView.translatesAutoresizingMaskIntoConstraints = false
        customInputView.fixConstraintsInView(contentView)
        customInputView.fillToSuperView(margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func setupSpecialCharsKeyboardTextView(_ contentView: UIView, from: SelectedLanguage) {
        let customInputView = SpecialCharactersKeyboard.instanceFromNib()
        customInputView.keyboardDelegate = self
        customInputView.selectedLanguage = from
        self.frame.size.height = (customInputView.frame.size.height + 60)
        //self.frame.size.height = customInputView.frame.size.height
        contentView.addSubview(customInputView)
        customInputView.translatesAutoresizingMaskIntoConstraints = false
        customInputView.fixConstraintsInView(contentView)
        customInputView.fillToSuperView(margin: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
    }

}
