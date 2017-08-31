//
//  InputForm.swift
//  anywaychat
//
//  Created by 河瀬悠 on 2017/08/30.
//  Copyright © 2017年 nakadoribooks. All rights reserved.
//

import UIKit

protocol InputFormDelegate{
    
    func onShowKeyboard(duration:TimeInterval, curve:UInt, keyboardFrame:CGRect)
    func onHideKeyboard(duration:TimeInterval, curve:UInt)
    func onCommitMessage(message:String)
    
}

class InputForm: NSObject, UITextFieldDelegate {
    
    static let Height:CGFloat = ContentHeight + (UI.margin * 2.0)
    private static let ContentHeight:CGFloat = 44.0
    
    let view = UIView()
    var delegate:InputFormDelegate?
    private let tf = UITextField()
    private let tfWrapper = UIView()
    private let commitButton = UIButton()
    private let commitLabel = UILabel()
    private let commitLabelOn = UILabel()
    
    override init() {
        super.init()
        
        let buttonWidth:CGFloat = 80
        
        view.frame = CGRect(x: 0, y: windowHeight() - InputForm.Height, width: windowWidth(), height: InputForm.Height)
        
        let bg = UIView()
        bg.frame.size = view.frame.size
        bg.backgroundColor = UI.whiteColor
        view.addSubview(bg)
        
        let line = UIView()
        line.frame = CGRect(x: 0, y: 0, width: windowWidth(), height: 1)
        line.backgroundColor = UI.greyColor
        view.addSubview(line)
        
        // tf
        tfWrapper.frame = CGRect(x: UI.margin, y: UI.margin, width: windowWidth() - buttonWidth - (UI.margin * 3.0), height: InputForm.ContentHeight)
        tfWrapper.backgroundColor = UI.lightGreyColor
        view.addSubview(tfWrapper)
        tf.frame = CGRect(x: UI.margin, y: 0, width: tfWrapper.frame.size.width - (UI.margin * 1.0), height: InputForm.ContentHeight)
        tf.placeholder = "メッセージ"
        tf.tintColor = UI.primaryColor
        tf.clearButtonMode = .always
        tf.textColor = UI.textColor
        tf.delegate = self
        tfWrapper.addSubview(tf)
        
        // button
        commitButton.frame = CGRect(x: windowWidth() - 80 - UI.margin, y: UI.margin, width: buttonWidth, height: InputForm.ContentHeight)
        commitButton.layer.cornerRadius = UI.buttonRadius
        commitButton.clipsToBounds = true
        commitButton.backgroundColor = UI.greyColor
        commitButton.isEnabled = false
        commitButton.addTarget(self, action: "tapCommit", for: .touchUpInside)
        view.addSubview(commitButton)
        
        commitLabel.frame.size = commitButton.frame.size
        commitLabel.textColor = UI.whiteColor
        commitLabel.textAlignment = .center
        commitLabel.font = UI.font(size: 18.0)
        commitLabel.text = "送信"
        commitButton.addSubview(commitLabel)
        
        commitLabelOn.frame.size = commitButton.frame.size
        commitLabelOn.textColor = UI.primaryColor
        commitLabelOn.textAlignment = .center
        commitLabelOn.font = UI.font(size: 18.0)
        commitLabelOn.text = "送信"
        commitLabelOn.alpha = 0
        commitButton.addSubview(commitLabelOn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private dynamic func tapCommit(){
        let message = tf.text!
        
        commitButton.isEnabled = false
        tf.text = ""
        
        let buttonOverlay = UI.createButtonOverlay(currentView: commitButton)
        buttonOverlay.backgroundColor = UI.successColor
        commitButton.insertSubview(buttonOverlay, at: 0)
        AloeChain().add(0.2, ease: .Ease) { (val) in
            buttonOverlay.transform = CGAffineTransform(scaleX: val, y: val)
            
            let scale = 1.0 - 0.05 * val
            self.commitButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }.call {
            self.commitButton.backgroundColor = UI.greyColor
        }.add(0.2, ease: .Ease, progress: { (val) in
            let scale = 0.95 + (0.05*val)
            self.commitButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            let reverse = 1.0 - val
            buttonOverlay.alpha = reverse
        }).call {
            buttonOverlay.removeFromSuperview()
        }.execute()
        
        delegate?.onCommitMessage(message: message)
    }
    
    private dynamic func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                print("keyboardWillShow no param")
                return
        }
        
        delegate?.onShowKeyboard(duration: duration, curve: curve, keyboardFrame: keyboardFrame)
        
        let toY:CGFloat = -keyboardFrame.size.height
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
            self.view.transform = CGAffineTransform(translationX: 0, y: toY)
        }, completion: { aaa in
            
        })
    }
    
    private dynamic func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? UInt  else {
                print("keyboardWillHide no param")
                return
        }
        
        delegate?.onHideKeyboard(duration: duration, curve: curve)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { aaa in
            
        })
    }
    
    // MARK UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = textField.text! + string
        let inputCount = str.characters.count
        
        if inputCount > 0{
            commitButton.isEnabled = true
            commitButton.backgroundColor = UI.primaryColor
        }else if (range.length==1 && string.characters.count == 0){
            commitButton.isEnabled = false
            commitButton.backgroundColor = UI.greyColor
        }
        
        return true
    }
    
    // MARK public
    
    func blur(){
        tf.resignFirstResponder()
    }
    
}
