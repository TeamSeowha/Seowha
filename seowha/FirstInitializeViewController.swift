//
//  FirstInitializeViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 28/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

class FirstInitializeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var etcTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var secondInitializeView: SecondInitializeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.view.backgroundColor = .clear
        
        let backItem = UIBarButtonItem()
        backItem.title = "뒤로가기"
        navigationItem.backBarButtonItem = backItem
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        secondInitializeView = storyBoard.instantiateViewController(withIdentifier: "SecondInitializeView") as? SecondInitializeViewController

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.nicknameTextField.delegate = self
        self.ageTextField.delegate = self
        self.etcTextField.delegate = self
        
        self.nicknameTextField.addBorderBottom(height: 1.0, color: UIColor(rgb: 0xEF706A))
        self.ageTextField.addBorderBottom(height: 1.0, color: UIColor(rgb: 0xEF706A))
        self.etcTextField.addBorderBottom(height: 1.0, color: UIColor(rgb: 0xEF706A))
        
        self.ageTextField.keyboardType = UIKeyboardType.numberPad
        
        self.sexSegmentedControl.tintColor =  UIColor(rgb: 0xEF706A)
        
        self.nextButton.backgroundColor = UIColor(rgb: 0xEF706A)
        self.nextButton.layer.borderWidth = 2.0
        self.nextButton.layer.cornerRadius = 5.0
        self.nextButton.layer.borderColor = UIColor(rgb: 0xEF706A).cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nicknameTextField.becomeFirstResponder()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.nicknameTextField) {
            self.ageTextField.becomeFirstResponder()
        } else if textField.isEqual(self.ageTextField) {
            self.ageTextField.resignFirstResponder()
        } else if textField.isEqual(self.etcTextField) {
            self.etcTextField.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nicknameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        etcTextField.resignFirstResponder()
    }
    
    @IBAction func sexSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 2:
            self.etcTextField.isEnabled = true
            etcTextField.becomeFirstResponder()
        default:
            self.etcTextField.isEnabled = false
            nicknameTextField.resignFirstResponder()
            ageTextField.resignFirstResponder()
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if let nickname = nicknameTextField.text, !nickname.isEmpty {
            if let age = ageTextField.text, !age.isEmpty {
                
                secondInitializeView.nickname = nickname
                secondInitializeView.age = Int(age)!
                
                if sexSegmentedControl.selectedSegmentIndex != 2 {
                    secondInitializeView.sex = sexSegmentedControl.selectedSegmentIndex == 0 ? "female" : "male"
                } else if let etc = etcTextField.text, !etc.isEmpty {
                    secondInitializeView.sex = etc
                } else {
                    showAlert(title: "시작하기 오류", message: "기타 성별을 입력하세요")
                    return
                }
            } else {
                showAlert(title: "시작하기 오류", message: "나이를 입력하세요")
                return
            }
        } else {
            showAlert(title: "시작하기 오류", message: "닉네임을 입력하세요")
            return
        }
        
        self.navigationController?.pushViewController(secondInitializeView, animated: true)
    }
}
