//
//  ViewController.swift
//  SlackLogin
//
//  Created by Ubinyou on 2021/03/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var placeHolderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var setWorkspace: UITextField!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    var tokens = [NSObjectProtocol]()
    deinit {
        tokens.forEach {NotificationCenter.default.removeObserver($0)}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setWorkspace.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.isEnabled = false
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            if let frameValue = noti.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                self?.containerBottomConstraint.constant = keyboardFrame.size.height
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                })
            }
        }
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            self?.containerBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self?.view.layoutIfNeeded()
            })
        })
    }
}
extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet : CharacterSet = { //사용하려고 하는 char를 set 형태로 inverted하여 저장함.
            var cs = CharacterSet.lowercaseLetters
            cs.insert(charactersIn: "1234567890")
            cs.insert(charactersIn: "-")
            cs.insert(charactersIn: ".")
            return cs.inverted
        }()
        if string.count > 0 { //string안에 charSet에 저장된 문자가 있으면, nil이 아니면서 else 스코프안에 return false가 반환.
            guard string.rangeOfCharacter(from: charSet) == nil else {
                return false
            }
        }
        let finalText = NSMutableString(string: textField.text ?? "")
        finalText.replaceCharacters(in: range, with: string)
        
        let font = textField.font ?? UIFont.systemFont(ofSize: 16)
        let dict = [NSAttributedString.Key.font: font]
        let width = finalText.size(withAttributes: dict).width
        
        placeHolderLeadingConstraint.constant = width
        
        if finalText.length == 0 {
            placeHolderLabel.text = "workspace-url.slack.com"
        }
        else {
            placeHolderLabel.text = ".slack.com"
        }
        nextBtn.isEnabled = finalText.length > 0
        return true
    }
}

