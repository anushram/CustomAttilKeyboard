//
//  CustomKeyboardManager.swift
//  CustomTamilKeyboard
//
//  Created by Ramkumar J on 25/07/23.
//

import Foundation
import UIKit

final public class CustomKeyboardManager {
    
    public static let shared = CustomKeyboardManager()
    
    public var textInputView: IllaguKeyboardView?
    
    public var onDoneEventReceived: ((_ targetView: UIKeyInput) -> Void)?
    
    private init() {
        
    }
    
    @objc public var enabled = false {
        didSet {
            if enabled {
                addObserverOfTextField()
                addObserverOfTextView()
            }else{
                removeObserverOfTextField()
                removeObserverOfTextView()
            }
        }
    }
    
    public var language: String = ""
    
    weak var inputView: UIView?
    
    func addObserverOfTextField() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCustomKeyboardTextField(_:)), name: Notification.Name(UITextField.textDidBeginEditingNotification.rawValue), object: nil)
    }
    
    func addObserverOfTextView(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCustomKeyboardTextView(_:)), name: Notification.Name(UITextView.textDidBeginEditingNotification.rawValue), object: nil)
    }
    
    @objc func showCustomKeyboardTextField(_ notification: Notification) {
        inputView = notification.object as? UIView
        if let textInput = inputView as? UITextField {
            if textInput.keyboardType != .numberPad {
                textInput.inputAccessoryView?.isHidden = true
                let keyboardView = IllaguKeyboardView.init(frame: .zero, targetInput: textInput, inputTextField: textInput, inputTextView: nil, language: language)
                textInput.inputView = keyboardView
                keyboardView.onEventReceived = onDoneEventReceived
            }else{
                //textInput.becomeFirstResponder()
            }
        }
    }
    
    @objc func showCustomKeyboardTextView(_ notification: Notification) {
        self.inputView = notification.object as? UIView
        if let textInput = self.inputView as? UITextView {
            textInput.resignFirstResponder()
            removeObserverOfTextView()
            textInput.inputAccessoryView?.isHidden = false
            let keyboardView = IllaguKeyboardView.init(frame: .zero, targetInput: textInput, inputTextField: nil, inputTextView: textInput, language: language)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                textInput.inputView = keyboardView
                self.textInputView = keyboardView
                keyboardView.onEventReceived = self.onDoneEventReceived
                textInput.becomeFirstResponder()
            }
        }
    }
    
    private func removeObserverOfTextField() {
        if let textInput = inputView as? UITextField {
            textInput.inputAccessoryView?.isHidden = true
            textInput.inputView = nil
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name(UITextField.textDidBeginEditingNotification.rawValue), object: nil)
    }
    
    private func removeObserverOfTextView(){
        if let textInput = inputView as? UITextView {
            textInput.inputAccessoryView?.isHidden = true
            textInput.inputView = nil
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name(UITextView.textDidBeginEditingNotification.rawValue), object: nil)
    }
    
}
