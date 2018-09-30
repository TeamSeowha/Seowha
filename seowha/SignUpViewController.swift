//
//  SignUpViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 26/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var db: Firestore!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmTextField.delegate = self
        
        self.emailTextField.addBorderBottom(height: 1.5, color: UIColor.white)
        self.passwordTextField.addBorderBottom(height: 1.5, color: UIColor.white)
        self.passwordConfirmTextField.addBorderBottom(height: 1.5, color: UIColor.white)
        
        self.emailTextField.attributedPlaceholder =
            NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.passwordConfirmTextField.attributedPlaceholder =
            NSAttributedString(string: "비밀번호 확인", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        self.signUpButton.layer.borderWidth = 2.0
        self.signUpButton.layer.cornerRadius = 5.0
        self.signUpButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailTextField.becomeFirstResponder()
    }
    
    @IBAction func agreeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if let email = emailTextField.text, !email.isEmpty {
            if let password = passwordTextField.text, !password.isEmpty {
                if let passwordConfirm = passwordConfirmTextField.text, !passwordConfirm.isEmpty {
                    if password == passwordConfirm {
                        if agreeButton.isSelected {
                            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                                if let error = error {
                                    print("Login error: \(error.localizedDescription)")
                                    
                                    self.showAlert(title: "로그인 오류", message: error.localizedDescription)
                                    
                                    return
                                }
                                
                                // User is signed in
                                // [START get_document]
                                let docRef = self.db.collection("users").document(Auth.auth().currentUser!.uid)
                                
                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        self.goToMainView()
                                    } else {
                                        // Document does not exist
                                        self.goToInitializeView()
                                    }
                                }
                                // [END get_document]
                            }
                        } else {
                            showAlert(title: "회원가입 오류", message: "개인정보 수집 이용에 동의해야 합니다")
                        }
                    } else {
                        showAlert(title: "회원가입 오류", message: "비밀번호를 확인하세요")
                    }
                } else {
                    showAlert(title: "회원가입 오류", message: "비밀번호 확인을 입력하세요")
                }
            } else {
                showAlert(title: "회원가입 오류", message: "비밀번호를 입력하세요")
            }
        } else {
            showAlert(title: "회원가입 오류", message: "이메일을 입력하세요")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.emailTextField) {
            self.passwordTextField.becomeFirstResponder()
        } else if textField.isEqual(self.passwordTextField) {
            self.passwordConfirmTextField.becomeFirstResponder()
        } else if textField.isEqual(self.passwordConfirmTextField) {
            self.passwordConfirmTextField.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.resignFirstResponder()
    }
    
    func goToInitializeView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initializeView = storyBoard.instantiateViewController(withIdentifier: "InitializeView")
        self.present(initializeView, animated: true, completion: nil)
    }
    
    func goToMainView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyBoard.instantiateViewController(withIdentifier: "MainView")
        self.present(mainView, animated: true, completion: nil)
    }
}
