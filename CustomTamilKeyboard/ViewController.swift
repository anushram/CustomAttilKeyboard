//
//  ViewController.swift
//  CustomTamilKeyboard
//
//  Created by Ramkumar J on 26/05/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    func deleteTextBackWord() {
        keyText.deleteBackward()
    }
    
    func didEnteredText(text: String) {
        keyText.insertText(text)
    }
    func returnTextField(){
        keyText.resignFirstResponder()
//        let frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 274)
//        let keyboardView = IllaguKeyboardView.init(frame: frame, inputField: keyText, language: "en")
//        keyText.inputView = keyboardView
    }
    
//    func deleteTextBackWord() {
//        keyText.deleteBackward()
//    }
//
//    func didEnteredText(text: String) {
//        keyText.insertText(text)
//    }
    
    @IBOutlet weak var keyText: UITextField!
    @IBOutlet weak var keyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let customInputView = BaseTamilView.instanceFromNib()
          //customInputView.inputField = keyText
//        customInputView.keyboardDelegate = self
//        let frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 274)
//        let keyboardView = IllaguKeyboardView.init(frame: frame, inputField: keyText)
//        keyboardView.delegate = self
//        keyText.inputView = keyboardView
        
        
        keyText.delegate = self
        keyTextView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomKeyboardManager.shared.enabled = true
        CustomKeyboardManager.shared.language = "ta"
        CustomKeyboardManager.shared.onDoneEventReceived = { target in
            if target is UITextView{
            }else if target is UITextField{
            }
        }
//        let keyboardView = IllaguKeyboardView.init(frame: .zero, targetInput: keyTextView, inputTextField: nil, inputTextView: keyTextView, language: "ta")
//        keyTextView.inputAccessoryView?.isHidden = false
//        keyTextView.inputView = keyboardView
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//        if string == "a"{
//           return false
//        }
        return true
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        print("globe",textField.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
}

